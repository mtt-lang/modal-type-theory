Note: the evaluator does not typecheck terms, so if you need to call 
a function like (λa: A. a) you can apply it to the unit value ().

K I = K*
  $ mtt eval <<EOF
  > <((λa: (A -> A). λb: B. a) (λa: A. a)) (),
  >  (λa: A. λb: B. b) ()>
  > EOF
  <λa. a, λb. b>

'Let .. in' expression
  $ mtt eval <<EOF
  > let y = () in (fun x: A. x) y
  > EOF
  ()

  $ mtt eval <<EOF
  > let f = fun x: A. < x, x > in f ()
  > EOF
  <(), ()>

  $ mtt eval <<EOF
  > let f = fun p: A * B. < snd p, fst p > in f < (), () >
  > EOF
  <(), ()>

  $ mtt eval <<EOF
  > (fun p: A * B. 
  > let f = fst p in
  > let s = snd p in
  > < s, f > ) < (), () >
  > EOF
  <(), ()>

Shadowing x
  $ mtt eval <<EOF
  > (let x = () in let x = fun a: A. a in x x)
  > EOF
  λa. a

Church numerals
  $ mtt eval <<EOF
  > let n0 = λf:F. λx:X . x in
  > let n1 = λf:F. λx:X . f x in
  > let n2 = λf:F. λx:X . f (f x) in
  > let n3 = λf:F. λx:X . f (f (f x)) in
  > let n4 = λf:F. λx:X . f (f (f (f x))) in
  > 
  > let true = λx:A. λy:B . x in
  > let false = λx:A . λy:B . y in
  > let if = λp:P. λt:A. λe:B. (p t) e in
  > 
  > let pair = λa:A . λb:B . λt:A -> B -> C . (t a) b in
  > let fstt = λp:A -> B -> C. p (λx:A. λy:B . x) in
  > let sndd = λp:A -> B -> C. p (λx:A . λy:B . y) in
  > 
  > let succ = λn:N. λf:F. λx:X. f ((n f) x) in
  > let pred = λn:N. λf:F. λx:X. sndd ( ( n (λp:P . ( pair (f (fstt p)) ) (fstt p) ) ) ( (pair x) x ) ) in
  > let minus = λn:N. λm:N. (m pred) n in 
  > 
  > let not = λb:B . ((if b) false) true in
  > let iszero = λn:N. (n (λx:N. false)) true in
  > let and = λn:N. λm:N. ((if n) m) false in
  > let eq = λn:N. λm:N. ( and (iszero ( (minus n) m)) ) (iszero ( (minus m) n)) in
  > 
  > let plus = λn:N. λm:N. λf:F. λx:X. (n f) ((m f) x) in
  > let mult = λn:N. λm:N. λf:F. λx:X. (n (m f)) x in
  > 
  > let fix = λf:F. (λx:X. f (λv:V. (x x) v)) (λx:X. f (λv:V. (x x) v)) in
  > let fact = λfact:F. λn:N. (((if (iszero n)) (λu:(). n1)) (λu:(). (mult n) (fact (pred n)))) () in
  > let factorial = fix fact in
  > 
  > let test1 = (eq n3) n2 in
  > let test2 = (eq n2) n3 in
  > let test3 = (eq n2) n2 in
  > let eqtests = (and ((and (not test1)) (not test2))) test3 in
  > let test4 = (eq n3) ((plus n2) n1) in
  > let test5 = (eq n3) ((plus n2) n2) in
  > let plustest = (and test4) (not test5) in
  > let test6 = (eq n2) ((mult n2) n1) in
  > let test7 = (eq n4) ((mult n2) n2) in
  > let multest = (and test6) test7 in
  > let factest = (eq ((mult n2) n3)) (factorial n3) in
  > let runtest = (and ((and ((and eqtests) plustest)) multest)) factest in runtest
  > EOF
  λx. λy : B. x
