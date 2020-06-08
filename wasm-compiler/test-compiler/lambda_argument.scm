((lambda (n)
       ((lambda (fact n) (fact fact n))
        (lambda (ft k) (if (= k 1) 1 (* k (ft ft (- k 1))))) n))
     5)