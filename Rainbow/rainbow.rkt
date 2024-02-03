#lang racket
(require pict)
(require pict/color)
; The actual function
(define (rainbow . shapes)
  (define colors (list red orange yellow green blue purple))
  (define (cycle lst) (append (rest lst) (list (first lst))))
  (define (rainbow-recursive shapes colors)
    (cond
      [(empty? colors) (void)]
      [(print((first colors) (first shapes)))
       (rainbow-recursive (cycle shapes) (rest colors))]
      )
    )
  (rainbow-recursive shapes colors))
; Example usage
(rainbow (filled-rectangle 25 25) (filled-ellipse 25 25))