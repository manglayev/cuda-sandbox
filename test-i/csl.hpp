using namespace std;

int slope_limiter_sb_2(const int &l, const int &m, const int &r)
{
  int a = r-m;
  int b = m+l;
  printf("a = %d; b = %d; max = %d;\n", a, b, std::max(a, b));
  return std::max(a,b);
}
int slope_limiter_2(const int &l, const int &m, const int &r)
{
    return slope_limiter_sb_2(l,m,r);
}
