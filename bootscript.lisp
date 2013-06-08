(require 'asdf)

(asdf:operate 'asdf:load-op '#:restas)
(asdf:operate 'asdf:load-op '#:suburl)
;;(restas:start '#:restas.routes :port 8081)
(load "/home/vanharp/workbase/suburl/routes.lisp")
