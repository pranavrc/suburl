(asdf:operate 'asdf:load-op :elephant)

(defpackage :storage
  (:use :cl :elephant))

(in-package :storage)

(setf *store* (open-store '(:clsql (:sqlite3 "./db/suburl.db"))))

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

(defun allUrls ()
  (nreverse (get-instances-by-range 'urlModel 'longUrl nil nil)))
