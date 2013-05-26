(asdf:operate 'asdf:load-op :elephant)

(defpackage :storage
  (:use :cl :elephant))

(in-package :storage)

(setf *store* (open-store '(:clsql (:sqlite3 "/home/pranav/workbase/suburl/db/suburl.db"))))

(defpclass urlModel ()
  ((longUrl :reader longUrl
	    :initarg :longUrl
	    :index t)
   (shortUrl :accessor shortUrl
	     :initarg :shortUrl
	     :index t)))

(defun getlongUrlFromShort (inputUrl)
  (longUrl (get-instance-by-value 'urlModel 'shortUrl inputUrl)))

(defun getshortUrlFromLong (inputUrl)
  (shortUrl (get-instance-by-value 'urlModel 'longUrl inputUrl)))

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

(defun replaceSubstr (string part replacement &key (test #'char=))
  ;; http://cl-cookbook.sourceforge.net/strings.html#manip
  (with-output-to-string (out)
    (loop with part-length = (length part)
       for old-pos = 0 then (+ pos part-length)
       for pos = (search part string
			 :start2 old-pos
			 :test test)
       do (write-string string out
			:start old-pos
			:end (or pos (length string)))
       when pos do (write-string replacement out)
       while pos))) 
