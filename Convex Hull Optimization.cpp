//https://codeforces.com/contest/319/problem/C
/*
#pragma GCC target("avx2")
#pragma GCC optimization("O3")
#pragma GCC optimization("unroll-loops")
ordered_set -> less -> less_equal
ordered_set find_by_order(k) -> k element
ordered_set order_of_key(k) -> returns the number of elements in a set strictly smaller than k
*/
#include <bits/stdc++.h>
#include <random>
//#include <ext/pb_ds/assoc_container.hpp>

using namespace std;
//using namespace __gnu_pbds;

//template<typename T> using ordered_set=tree<T,null_type,less<T>,rb_tree_tag,tree_order_statistics_node_update>;
mt19937_64 rng(chrono::steady_clock::now().time_since_epoch().count());

const long long maxn = 3e5 + 123;
const long long inf = 1e9 + 123;
const long long linf = 1e18 + 123;
const long long mod = 1e9 + 7;
const double eps = 1e-9;
const double pi = acos(-1);
int dx[8] = {0, 1, -1, 0, 1, -1, 1, -1};
int dy[8] = {1, 0, 0, -1, 1, 1, -1, -1};

long long dp[maxn], a[maxn], b[maxn];

vector< pair<long long, long long> > s;

long double intersect(pair<long long, long long> l1, pair<long long, long long> l2){
    long double ans = (l2.second - l1.second);
    ans = (ans / (l1.first - l2.first));
    return ans;
}
 
bool bad(pair<long long, long long> l1, pair<long long, long long> l2, pair<long long, long long> l3){
    long double q1 = intersect(l1, l2);
    long double q2 = intersect(l1, l3);
    return q1 >= q2;
}
 
void add(pair<long long, long long> l){
    int sz = s.size();
    while(sz > 1){
        if(bad(s[sz - 2], s[sz - 1], l)){
            s.pop_back();
            sz --;
        }
        else{
            break;
        }
    }
    s.push_back(l);
 
}
 
long long calc(pair<long long, long long> x, long long y){
    long long ans = x.first * y + x.second;
    return ans;
}
 
long long find(int x){
    int l = 0,r = s.size() - 1;
    while(l < r){
        int mid=(l + r) / 2;
        if(calc(s[mid], x) > calc(s[mid + 1], x)){
            l = mid + 1;
        }
        else{
            r = mid;
        }
    }
    return calc(s[r], x);
}

int main(){
    freopen("input.cpp", "r", stdin);
    freopen("output.cpp", "w", stdout);
    ios_base::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);
    int n;
    cin >> n;
    for (int i = 1; i <= n; i++){
        cin >> a[i];
    }
    for (int i = 1; i <= n; i++){
        cin >> b[i];
    }
    /*
    SLOW 
    dp[1] = 0;
    for (int i = 2; i <= n; i++){
        dp[i] = linf;
        for (int j = 1; j < i; j++){
            dp[i] = min(dp[i], dp[j] + b[j] * a[i]);
        }
    }
    */

    add({b[1], dp[1]});
    for (int i = 2; i <= n; i++){
        dp[i] = find(a[i]);
        add({b[i], dp[i]});
    }
    cout << dp[n];
    exit(0);
}
