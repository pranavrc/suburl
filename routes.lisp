(asdf:operate 'asdf:load-op :cl-who)
(asdf:operate 'asdf:load-op :restas)
(asdf:operate 'asdf:load-op :cl-ppcre)

(import :storage)

(restas:define-module :restas.routes
    (:use :cl))

(in-package :restas.routes)
(restas:debug-mode-on)

(setf (who:html-mode) :html5)

(restas:define-route main ("" :method :get)
  (pathname "~/workbase/suburl/res/index.html"))

(restas:define-route urlSubmit ("" :method :post)
  (storage::addPair (hunchentoot:post-parameter "longURL") (hunchentoot:post-parameter "shortURL"))
  (who:with-html-output-to-string (out)
    (:a :href (hunchentoot:post-parameter "longURL") (who:str (hunchentoot:post-parameter "shortURL")))))

(restas:start :restas.routes :port 8080)
