# You shouldn't place Bond.complete statements before requiring this file
# unless you're also reproducing this Bond.debrief
Bond.debrief(:default_search=>:underscore) unless Bond.config[:default_search]
Bond.debrief(:default_mission=>:default) unless Bond.config[:default_mission]
Bond.complete(:method=>/system|`/, :action=>:shell_commands)
Bond.complete(:method=>'require', :action=>:method_require, :search=>false)

# irb/completion reproduced without the completion quirks
# Completes classes and constants
Bond.complete(:on=>/(((::)?[A-Z][^:.\(]*)+)::?([^:.]*)$/, :action=>:constants, :search=>false)
# Completes absolute constants
Bond.complete(:on=>/::([A-Z][^:\.\(]*)$/, :search=>false) {|e|
  Object.constants.grep(/^#{Regexp.escape(e.matched[1])}/).collect{|f| "::" + f}
}
# Completes symbols
Bond.complete(:on=>/(:[^:\s.]*)$/) {|e|
  Symbol.respond_to?(:all_symbols) ? Symbol.all_symbols.map {|f| ":#{f}" } : []
}
# Completes global variables
Bond.complete(:on=>/(\$[^\s.]*)$/, :search=>false) {|e|
  global_variables.grep(/^#{Regexp.escape(e.matched[1])}/)
}
# Completes files
Bond.complete(:on=>/[\s(]["']([^'"]*)$/, :search=>false, :action=>:quoted_files, :place=>:last)
# Completes any object's methods
Bond.complete(:object=>"Object", :place=>:last)
# Completes method completion anywhere in the line
Bond.complete(:on=>/([^.\s]+)\.([^.\s]*)$/, :object=>"Object", :place=>:last)