1:@:(dbr bind Debug)@:(9!:19)2^_44[(echo^:ECHOFILENAME) './gh.ijs'
NB. H. ------------------------------------------------------------------

(^ -: '' H. '') x=:0.01*_100+?40$200
(^ -: 1  H. 1 ) x
(^ -: '' H. '') x=:j./0.01*_100+?2 40$200
(^ -: 1  H. 1 ) x
*./ 1e_14 > | (^ - 40&('' H. '')) x=:0.01*_100+?40$200
*./ 1e_14 > | (^ - 40&(1  H. 1 )) x
*./ 1e_14 > | (^ - 40&('' H. '')) x=:j./0.01*_100+?2 40$200
*./ 1e_14 > | (^ - 40&(1  H. 1 )) x

f =: '' H. ''
(f -: _&f) x=:0.001*_1000+?40$2000
(f -: _&f) x=:0.001*j./_1000+?2 40$2000

rf=: 1 : '(,m)"_ ^!.1/ i.@['       
L1=: 2 : 'm rf %&(*/) n rf'
L2=: (i.@[ ^~ ]) % (!@i.@[)
H =: 2 : '(m L1 n +/ . * L2) " 0'


NB. Tchebyshev polynomials

T       =: (,1)"_ ` (i.@2:) ` ((0:,+:@$:@(-&1)) - $:@(-&2),0 0"_) @. (2&<.)
cos     =: 2&o.
roots   =: cos @ o. @ (>:@+:@i. % +:)
extrema =: cos @ o. @ (i. % ])

test=: 3 : 0
 n=: y
 x=. 0.001*_1000+?40$2000
 f=. (n,-n) H. 0.5 
 assert. 1e_10 > | 10&f@(-:@-.) roots n
NB. not 901 assert. 1e_16 > (+/|f t. i.1+n) %~| f@(-:@-.) roots n
NB. not 901 assert. 1e_16 > (+/|f t. i.1+n) %~| (_1^i.n) - f@(-:@-.) extrema n
 assert. 0 = (f - (1+n)&f) x
 g=. ((-n),n) H. 0.5
 assert. 1e_8  > | ((T n)&p. - 10&g@(-:@-.)) x 
 1
)

test"(0) 1 2 3 4 5 6 7

   (1 H. '' -: 1 1   H. 1  ) x=:0.01*_50+?40$100
   (1 H. '' -: 1 1 1 H. 1 1) x
10 (1 H. '' -: 1 1   H. 1  ) x
10 (1 H. '' -: 1 1 1 H. 1 1) x

*./ 0 = 0 (?4$13) H. (?2$13) x=:0.01*_50+?40$1000
*./ 1 = 1 (?3$13) H. (?4$13) x
*./, 0 1 = 0 1 (?2$13) H. (?1$13)/ x

10 (2 3 H. 4 -: */@(2 3&(^!.1/)) H. (4&(^!.1))) x=:0.01*?10$30
   (2 3 H. 4 -: */@(2 3&(^!.1/)) H. (4&(^!.1))) x

sin =: 1&o.
sinh=: 5&o.
cos =: 2&o.
cosh=: 6&o.

sinb =: * '' H. 3r2@(_1r4&*)@*:
sinhb=: * '' H. 3r2@( 1r4&*)@*:
cosb =:   '' H. 1r2@(_1r4&*)@*:
coshb=:   '' H. 1r2@( 1r4&*)@*:

(sin  -: sinb ) z=.0.001*_1000+   ?  4 10$2000
(sin  -: sinb ) z=.0.001*_1000+j./?2 4 10$2000
(sinh -: sinhb) z=.0.001*_1000+   ?  4 10$2000
(sinh -: sinhb) z=.0.001*_1000+j./?2 4 10$2000
(cos  -: cosb ) z=.0.001*_1000+   ?  4 10$2000
(cos  -: cosb ) z=.0.001*_1000+j./?2 4 10$2000
(cosh -: coshb) z=.0.001*_1000+   ?  4 10$2000
(cosh -: coshb) z=.0.001*_1000+j./?2 4 10$2000

'domain error' -: ex '1  H. a.'
'domain error' -: ex 'a. H. 1 '
'domain error' -: ex '1  H. a:'
'domain error' -: ex 'a: H. 1 '

'rank error'   -: ex '(i.2 3) H. 1'
'rank error'   -: ex '1 H. (i.2 3)'

'domain error' -: 3 _5    (1 H. 1 etx) 0.5
'domain error' -: 'abc'   (1 H. 1 etx) 0.5
'domain error' -: (2;3 4) (1 H. 1 etx) 0.5
'domain error' -: 3 4     (1 H. 1 etx) 'ab'
'domain error' -: 3 4     (1 H. 1 etx) 2;3 4

'length error' -: 3 4     (1 H. 1 etx) 5 6 7


NB. H. verb arguments ---------------------------------------------------

X     =: +/ . *
eterm =: (i.@[ ^~ ]) % !@i.@[
rf    =: 1 : '(,u)"_ ^!.1/ i.@['
coeff =: 2 : 'u rf %&(*/) v rf'
prf   =: 1 : '[: */ (,u)"_ ^!.1/ ]'   NB. product of rising factorials
H     =: 2 : '(u % v)@i.@[ X eterm'   NB. u H  v  models  u H. v
H1    =: 2 : 'u coeff v X eterm'      NB. m H1 n  models  m H. n  
H2    =: 2 : '(u prf) H. (v prf)'     NB. m H2 n  models  m H. n

1 -: ] H. >: 1

p  =: */@(2 3&(^!.1/))
q  =: 4&(^!.1)
r  =: %/@(2 4 3&(^!.1/))
 
f0 =: 2 3 H1 4 " 0
f1 =: 2 3 H. 4
f2 =: p H  q  " 0
f3 =: p H. q
f4 =: r H  1: " 0
f5 =: r H. 1:

n=:(i.6),10 15 20
x=:0.34
n (f0 -: f1) x
n (f2 -: f3) x
n (f4 -: f5) x
n (f1 -: f3) x
n (f3 -: f5) x
n (2 3 H. 4 -: 2 3 H2 4) x

*./ 0 = 0 f5 x=:0.001*?4$100
*./ 1 = 1 f5 x
*./ , 0 1 = 0 1 f5/ x

(f1 -: f5) x=:0.001*_500+?10$1000
_ (f1 -: f5) x

70 (f1 -: p   H. q) x=:0.001*_500+?10$1000
70 (f1 -: p   H. 4) x
70 (f1 -: 2 3 H. q) x

'rank error'   -: 5 (i.2 3)"_ H. '' etx 2 3
'length error' -: 5 i.@2:     H. '' etx 2 3
'domain error' -: 5 'abcde'"_ H. '' etx 2 3


NB. H. further identities -----------------------------------------------

NB. Abramowitz & Stegun 15.1.3

((^.@-. % -) -: 1 1 H. 2) z=. j./1e_5*_5e4+?2 20$1e5

(^.@>: -: [ * 1 1 H. 2@-) x=: (0.01&<@| # ]) 0.001*_700+40 ?@$1401
(^.@>: -: [ * 1 1 H. 2@-) x=: (0.01&<@| # ]) (0.002*?40$400) r. ?40$1000

NB. Abramowitz & Stegun 15.1.7

f7 =: 1r2 1r2 H. 3r2 @-@*:          
g7 =: 1   1   H. 3r2 @-@*: * >:&.*: 
h7 =: ^.@(+ >:&.*:) % ]

(f7 -: g7) x=:(+ {&0.004 _0.004@(0&>) * 0.004&>@|) 0.001*_999+?40$1999
(f7 -: h7) x

NB. Abramowitz & Stegun 15.1.8

f8 =: 1 : '^&(-u)@-.'
g8 =: 1 : 'u H. ($0)'
h8 =: 1 : '(u,1) H. 1'

(a f8 -: a g8) x=:0.01*_50+?40$100 [ a=.0.1*?50
(a f8 -: a h8) x
(a f8 -: a g8) x=:j./0.01*_50+?2 40$100
(a f8 -: a h8) x

*./ 1e_10 > | (a f8 - 50&(a g8)) x=:0.01*_30+?40$60
*./ 1e_10 > | (a f8 - 50&(a h8)) x
*./ 1e_10 > | (a f8 - 50&(a g8)) x=:j./0.01*_30+?2 40$60
*./ 1e_10 > | (a f8 - 50&(a h8)) x

*./ 1e_10 > | (a f8 -: 50&(a g8)) x=:0.001*_1000+?40$2000 [ a=.1
*./ 1e_10 > | (a f8 -: 50&(a g8)) x [ a=.1.5
*./ 1e_10 > | (a f8 -: 50&(a g8)) x [ a=.2
*./ 1e_10 > | (a f8 -: 50&(a g8)) x [ a=.2.3

NB. Abramowitz & Stegun 15.1.13

f13 =: 1 : '(0 1r2+u)H.(1+2*u)'
g13 =: 1 : '(2^2*u)"_ * (1: + %:@-.) ^ (_2*u)"_'
h13 =: 1 : '%:@-. * (1 1r2+u) H. (1+2*u)'

(0.2 f13 -: 0.2 g13) x=:0.001*_990+?40$1981
(0.2 f13 -: 0.2 h13) x
(2   f13 -: 2   g13) x
(2   f13 -: 2   h13) x
(5   f13 -: 5   g13) x
(5   f13 -: 5   g13) x

NB. Abramowitz & Stegun 15.1.14

f14 =: 1 : '(u,1r2+u) H. (2*u)'     
g14 =: 1 : '(2^_1+2*u)"_ * %@%:@-. * >:@%:@-. ^ (1-2*u)"_'

(0.2 f14 -: 0.2 g14) x=:0.001*_990+?40$1981
(2   f14 -: 2   g14) x
(3   f14 -: 3   g14) x
(4   f14 -: 4   g14) x

NB. Abramowitz & Stegun 15.1.17

sin =: 1&o.
cos =: 2&o.
f17 =: 1 : '(u,-u) H. 1r2 @ (*:@sin)'
g17 =: 1 : 'cos @ ((2*u)&*)'

*./ 1e_14>| (0.4 f17 - 0.4 g17) x=:0.001*_1000+?40$2001
*./ 1e_14>| (1   f17 - 1   g17) x
*./ 1e_14>| (1.4 f17 - 1.4 g17) x
*./ 1e_14>| (3   f17 - 3   g17) x

NB. modified Bessel fn of various orders; A&S Table 9.8, 9.9, 9.10

Bessel =: 1 : '(($0) H. (u+1) * ^&(-:u) % (!u)"_)@:*:@:-:'

f0 =: 0 Bessel * ^@-
1e_10 > | 1            - f0 0
1e_10 > | 0.9071009258 - f0 0.1
1e_10 > | 0.4657596076 - f0 1     NB. A&S say 96077
1e_10 > | 0.3085083225 - f0 2
1e_10 > | 0.1835408126 - f0 5
1e_10 > | 0.1278333371 - f0 10
1e_10 > | 0.0897803119 - f0 20

f1 =: 1 Bessel * ^@-
1e_10 > | 0            - f1 0
1e_10 > | 0.1564208032 - f1 0.5
1e_10 > | 0.2079104154 - f1 1
1e_10 > | 0.1968267133 - f1 3
1e_10 > | 0.1639722669 - f1 5
1e_10 > | 0.1160577582 - f1 11
1e_10 > | 0.0875062222 - f1 20

f2a =: 2 Bessel * %@*:
1e_10 > | 0.1251041992 - f2a 0.1
1e_10 > | 0.1357476698 - f2a 1
1e_10 > | 0.2042345837 - f2a 2.5
1e_10 > | 0.4013868359 - f2a 4
1e_10 > | 0.7002245987 - f2a 5     NB. A&S say 45988

f2 =: 2 Bessel * ^@-
1e_9  > | 0.117951906  - f2 5
1e_9  > | 0.103580801  - f2 10
1e_9  > | 0.081029690  - f2 20

1e_6 > | 2.8791e_2 - (3 Bessel * ^@-) 2
1e_7 > | 6.8654e_3 - (4 Bessel * ^@-) 2
1e_7 > | 1.3298e_3 - (5 Bessel * ^@-) 2
1e_8 > | 2.1656e_4 - (6 Bessel * ^@-) 2
1e_9 > | 3.0402e_5 - (7 Bessel * ^@-) 2
1e_10> | 3.7487e_6 - (8 Bessel * ^@-) 2
1e_11> | 4.1199e_7 - (9 Bessel * ^@-) 2

1e_8 > | 0.29462538 - (1e9 "_ * ^&_10 * 10 Bessel) 2
1e_8 > | 1.32920036 - (1e11"_ * ^&_11 * 11 Bessel) 2
1e_6 > | 0.411087   - (1e24"_ * ^&_20 * 20 Bessel) 2
1e_6 > | 0.976669   - (1e26"_ * ^&_21 * 21 Bessel) 2

1: 0 : 0  NB. removed from 901
NB. a H. b t. -----------------------------------------------------------

k =: i. n=:10

(1 H. 1  t. k) -: %!k
(1 H. 1  t: k) -: n$1
(0&(1 H. 1) t. k) -: n{.%!0{.k
(1&(1 H. 1) t. k) -: n{.%!1{.k
(2&(1 H. 1) t. k) -: n{.%!2{.k
(3&(1 H. 1) t. k) -: n{.%!3{.k
(4&(1 H. 1) t. k) -: n{.%!4{.k
(5&(1 H. 1) t. k) -: n{.%!5{.k

(1 H. '' t. k) -: n$1
(1 H. '' t. k) -: +/\^:0 n$1
(2 H. '' t. k) -: +/\^:1 n$1
(3 H. '' t. k) -: +/\^:2 n$1
(4 H. '' t. k) -: +/\^:3 n$1
(5 H. '' t. k) -: +/\^:4 n$1

(_1 H. '' t. k) -: (_1^k)*k!1
(_2 H. '' t. k) -: (_1^k)*k!2
(_3 H. '' t. k) -: (_1^k)*k!3
(_4 H. '' t. k) -: (_1^k)*k!4
(_5 H. '' t. k) -: (_1^k)*k!5

(1 1 H. 2 t. k) -: %>:k


NB. a H. b D. 1 ---------------------------------------------------------

f =: 1 H. '' D. 1
g =: ^&_2@-.
(f -: g) x=:0.001*_900+?20$1800

f =: 1.5 H. '' D. 1
g =: 1.5"_ * ^&_2.5@-.
(f -: g) x=:0.001*_900+?20$1800

)

NB. H. erf and N(0,1) ---------------------------------------------------

NB. by Ewart Shaw

erf   =: 1 H. 1.5@*: * 2p_0.5&* % ^@:*:
n01cdf=: -: @: >: @: erf @: ((%:0.5)&*)   NB. CDF of N(0,1)

1e_10 > | (erf 0.5) - 0.5204998778
1e_10 > | (erf 1  ) - 0.8427007929
1e_10 > | (erf 1.5) - 0.9661051465

1e_15 > | (n01cdf 0  ) - 0.5
1e_15 > | (n01cdf 0.5) - 0.691462461274013
1e_15 > | (n01cdf 1.0) - 0.841344746068543
1e_15 > | (n01cdf 1.5) - 0.933192798731142
1e_15 > | (n01cdf 2.0) - 0.977249868051821


4!:55 ;:'Bessel H H1 H2 T X a coeff cos cosb '
4!:55 ;:'cosh coshb erf eterm extrema f f0 f1 f13 f14 f17 '
4!:55 ;:'f2 f2a f3 f4 f5 f7 f8 g g13 g14 '
4!:55 ;:'g17 g7 g8 h h13 h7 h8 k L1 L2 n n n01cdf p '
4!:55 ;:'prf q r rf roots sin sinb sinh sinhb test x z '


