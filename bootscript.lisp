(require 'asdf)

(asdf:operate 'asdf:load-op '#:restas)
(push "/home/vanharp/workbase/suburl/" asdf:*central-registry*)
(asdf:operate 'asdf:load-op '#:suburl)
;;(restas:start '#:restas.routes :port 8081)
(load "/home/vanharp/workbase/suburl/routes.lisp")
