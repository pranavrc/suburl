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

(restas:define-route main ("" :method :get)
  (pathname "~/workbase/suburl/res/index.html"))

(restas:define-route urlSubmit ("" :method :post)
  (cond
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

(restas:start :restas.routes :port 8080)
