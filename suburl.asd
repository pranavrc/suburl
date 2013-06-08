(in-package :asdf)

(asdf:defsystem #:suburl
	:depends-on (#:cl-who #:hunchentoot
			     #:cl-ppcre #:elephant)
	:description "suburl: Substitution-based URL Shortener."
	:version "1.0"
	:author "Pranav Ravichandran <me@onloop.net>"
	:license "WTFPL <http://en.wikipedia.org/wiki/WTFPL>"
	:components ((:file "utils")
		(:file "routes" :depends-on ("utils"))))
