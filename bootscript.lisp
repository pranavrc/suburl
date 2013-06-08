(require 'asdf)

(asdf:operate 'asdf:load-op '#:suburl)
;;(restas:start '#:restas.routes :port 8080)
(load "/home/vanharp/workbase/suburl/routes.lisp")
