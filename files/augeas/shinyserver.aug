(* Shiny Server configuration module for Augeas

Authors: Adapted from the Nginx module by
         Ian Berry <iberry@barracuda.com> and
         Raphael Pinson <raphael.pinson@camptocamp.com>

About: Reference

   This module was built to support Shiny Server configuration.

About: License
   This file is licenced under the LGPL v2+, like the rest of Augeas.

About: Configuration files
   This lens applies to /etc/shiny-server/shiny-server.conf.

About: Examples
   The <Test_ShinyServer> file contains various examples and tests.

*)

module ShinyServer =
autoload xfm

(* Variable: block_re
     The keywords reserved for block entries *)
let block_re = "server"

(* All block keywords, including the ones we treat specially *)
let block_re_all = block_re | "location" | "admin" | "auth_active_dir"

(* View: simple
     A simple entry *)
let simple =
     let kw = Rx.word - block_re_all
  in let sto = store /[^ \t\n;][^;]*/ . Sep.semicolon
  in [ Util.indent . key kw . Sep.space . sto . (Util.eol|Util.comment_eol) ]

let arg (name:string) (rx:regexp) =
  [ label name . Sep.space . store rx ]

(* Match any argument (as much as possible) *)
let any_rx =
  let bare_rx = /[^" \t\n{][^ \t\n{]*/ in
  let dquote_rx = /"([^\"]|\\.)*"/ in
  bare_rx | dquote_rx

let any_arg (name:string) = arg name any_rx

(* 'if' conditions are enclosed in matching parens which we can't match
   precisely with a regular expression. Instead, we gobble up anything that
   doesn't contain an opening brace. That can of course lead to trouble if
   a condition actually contains an opening brace *)
let block_if = key "if"
             . arg "#cond" /\(([^ \t\n{]|[ \t\n][^{])*\)/

let block_location = key "location"
  . (arg "#comp" /=|~|~\*|\^~/)?
  . any_arg "#uri"

let block_head = key block_re
  | block_location

(* View: block
     A block containing <simple> entries *)
let block (entry : lens) =
  [ Util.indent . block_head
  . Build.block_newlines entry Util.comment
  . Util.eol ]

let rec directive = simple | block directive

(* View: lns *)
let lns = ( Util.comment | Util.empty | directive )*

let xfm = transform lns (incl "/etc/shiny-server/shiny-server.conf")
