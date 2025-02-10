(in-package :cl-woo-server)

(defvar *storage-file* "res/storage.txt")

(defun handle-post (env)
  (let* ((content-length (getf env :content-length))
         (raw-body (getf env :raw-body))
         (body (when raw-body
                 (with-output-to-string (out)
                   (loop for i from 1 to content-length
                         do (write-char (read-char raw-body) out))))))
    (when body
      (with-open-file (stream *storage-file*
                              :direction :output
                              :if-does-not-exist :create
                              :if-exists :append)
        (format stream "~a~%" body)))
    '(200 (:content-type "text/plain") ("String stored successfully."))))

(defun handle-get (env)
  (declare (ignore env))
  (let ((content (with-open-file (stream *storage-file*
                                         :direction :input
                                         :if-does-not-exist nil)
                   (if stream
                       (with-output-to-string (out)
                         (loop for line = (read-line stream nil)
                               while line
                               do (format out "~a~%" line)))
                       "No stored strings."))))
    `(200 (:content-type "text/plain") (,content))))

(defun handle-request (env)
  (let ((method (getf env :request-method))
        (path (getf env :path-info)))
    (cond
      ((and (string= method "POST") (string= path "/store"))
       (handle-post env))
      ((and (string= method "GET") (string= path "/retrieve"))
       (handle-get env))
      (t
       '(404 (:content-type "text/plain") ("Not Found"))))))

(defun start-server ()
  (woo:run #'handle-request :port 5000))
