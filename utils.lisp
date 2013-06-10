(asdf:operate 'asdf:load-op :elephant)
(asdf:operate 'asdf:load-op :cl-ppcre)

(defpackage :storage
  (:use :cl :cl-ppcre :elephant))

(in-package :storage)

(setf *store* (open-store '(:clsql (:sqlite3 "/home/vanharp/workbase/suburl/db/suburl.db"))))

(defpclass urlModel ()
  ((longUrl :reader longUrl
	    :initarg :longUrl
	    :index t)
   (shortUrl :reader shortUrl
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
    ;;(unless (or (longUrlExists inputlongUrl) (shortUrlExists inputShortUrl))
    (make-instance 'urlModel :longUrl inputLongUrl :shortUrl inputShortUrl)))

(defun allUrls ()
  (nreverse (get-instances-by-range 'urlModel 'longUrl nil nil)))

(defun printAllUrls ()
  (mapcar #'(lambda (each) (format t "~A - ~A~%" (storage::shortUrl each) (storage::longUrl each))) (storage::allUrls)))

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

(defun stringSplit (string delim)
  ;; Splits a string into substrings around the delimiter.
  (loop for x = 0 then (1+ y)
     as y = (position delim string :start x)
     collect (subseq string x y)
     while y))

(defun concatList (target)
  ;; Takes a list of strings and concatenates
  ;; them into a single string.
  (format nil "~{~a~}" target))

(defun mergeListItems (firstList secondList delim)
  ;; Takes two lists, and returns a list of alternately
  ;; concatenated items.
  (mapcar #'(lambda (x y) (concatenate 'string x delim y))
	  firstList secondList))

(defun validateUrl (regex target-string &key (start 0) (end (length target-string)))
  ;; Checks if target-string matches the given regex.
  (let ((sum 0))
    (ppcre:do-matches (s e regex target-string nil :start start :end end)
      (incf sum (- e s)))
    (if (= (/ sum (- end start)) 1)
	t
	nil)))
  
(defun scanUrl (input)
  ;; Scans URL to check for protocol.
  (and (cl-ppcre:scan "^(https?|ftp|file)://.+$" input) t))

(let ((urlRegex (ppcre:create-scanner "[^a-zA-Z0-9_\\-\\/\\:\\[\\]\\*.]")))
  (defun urlEncode (string)
    "URL-encodes a string."
    ;; won't work for Corman Lisp because non-ASCII characters aren't 8-bit there
    ;; From weitz.de/cl-ppcre examples.
    (flet ((convert (target-string start end match-start match-end reg-starts reg-ends)
             (declare (ignore start end match-end reg-starts reg-ends))
             (format nil "%~2,'0x" (char-code (char target-string match-start)))))
      (ppcre:regex-replace-all urlRegex string #'convert))))
