/*
  Note, this test is important because p picks up two edges from q at
  the same step of the algorithm.  This gives us a chance to catch a
  potential regression in graph construction (due to context
  clobbering in FGL)
 */
int a;
int b;
int c;
int d;

int * p;
int * q;
int * r;
int ** pq;
int ** pp;

void callee(int ** ptr1, int ** ptr2)
{
  *ptr1 = *ptr2;
}

void caller()
{
  callee(pp, pq);
  callee(pq, pp);
}

void setup()
{
  q = &a;
  q = &b;
  p = &c;
  pq = &q;
  pp = &p;
}
