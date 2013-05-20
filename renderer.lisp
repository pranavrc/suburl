(asdf:operate 'asdf:load-op :cl-who)
(asdf:operate 'asdf:load-op :restas)

(restas:define-module :restas.renderer
    (:use :cl))

(in-package :restas.renderer)
(restas:debug-mode-on)

(setf *store* (open-store '(:clsql (:sqlite3 "/tmp/suburl.db"))))

(defpclass urlModel ()
  ((longUrl :reader longUrl
	    :initarg :longUrl
	    :index t)
   (shortUrl :accessor shortUrl
	     :initarg :shortUrl
	     :index t)))

(defun getlongUrl (inputUrl)
  (get-instance-by-value 'urlModel 'longUrl inputUrl))

(defun getshortUrl (inputUrl)
  (get-instance-by-value 'urlModel 'shortUrl inputUrl))

(defun longUrlExists (url)
  (getlongUrl url))

(defun shortUrlExists (url)
  (getshortUrl url))

(defun addPair (inputLongUrl inputShortUrl)
  (with-transaction ()
    (unless (or (longUrlExists inputlongUrl) (shortUrlExists inputShortUrl))
      (make-instance 'urlModel :longUrl inputLongUrl :shortUrl inputShortUrl))))
