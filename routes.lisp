(asdf:operate 'asdf:load-op :cl-who)
(asdf:operate 'asdf:load-op :restas)
(asdf:operate 'asdf:load-op :cl-ppcre)

(import :storage)

(restas:define-module :restas.routes
    (:use :cl))

(in-package :restas.routes)
(restas:debug-mode-on)

(defparameter *response* "")

(setf (who:html-mode) :html5)

(restas:define-route main ("")
  (pathname "~/workbase/suburl/res/index.html"))

(restas:define-route css ("index.css")
  (pathname "~/workbase/suburl/res/index.css"))

(restas:define-route favicon ("favicon.ico")
  (pathname "~/workbase/suburl/res/favicon.ico"))

(restas:define-route loader ("loader.gif")
  (pathname "~/workbase/suburl/res/loader.gif"))

(restas:define-route urlSubmit ("" :method :post)
  (cond
    ((not (storage::scanUrl (hunchentoot:post-parameter "longURL")))
     (setf *response* "Invalid URL (Missing Protocol)."))
    ((or (not (storage::validateUrl "((?:[A-Za-z0-9_]*))"
				    (hunchentoot:post-parameter "shortURL")))
	 (not (< (length (hunchentoot:post-parameter "shortURL")) 11)))
     (setf *response* "Short URLs can contain only alphanumeric characters or underscore,
 and cannot be more than 10 characters in length."))
    ((storage::longUrlExists (hunchentoot:post-parameter "longURL"))
     (setf *response* 
	   (who:with-html-output-to-string (out)
	     (:p "Link already exists at Short URL: ")
	     (:a :href 
		 (hunchentoot:post-parameter "longURL")
		 (who:str
		  (storage::shortUrl (storage::getlongUrl (hunchentoot:post-parameter "longURL"))))))))
    ((storage::shortUrlExists (hunchentoot:post-parameter "shortURL"))
     (setf *response* "Short URL exists. Try another."))
    (t (progn
	 (storage::addPair (hunchentoot:post-parameter "longURL") (hunchentoot:post-parameter "shortURL"))
	 (setf *response* (who:with-html-output-to-string (out)
			    (:a :href (hunchentoot:post-parameter "longURL") (who:str (hunchentoot:post-parameter "shortURL"))))))))
  *response*)

(restas:define-route redir (":(input)/*params")
  (if (not (storage::getshortUrl input))
      (progn
	(setf *response* "Invalid URL.")
	*response*)
      (progn
	(setf *response*
	      (storage::concatList
	       (storage::mergeListItems
		(ppcre:split "\\[\\*\\]" (storage::longUrl (storage::getshortUrl input)))
		(storage::stringSplit (first params) #\,)
		"")))
	(restas:redirect *response*))))

(restas:start :restas.routes :port 8080)
