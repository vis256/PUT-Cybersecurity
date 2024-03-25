# Computer projects

# 1. Find the sum of the terms of a geometric series.
def geometric_series(a, r, n):
    if n == 0:
        return a
    else:
        return a + r * geometric_series(a, r, n-1)
    
print(geometric_series(1, 2, 3))

# 2. Evaluate n!.
def n_factorial(n):
    if n == 0:
        return 1
    else:
        return n * n_factorial(n-1)
    
print(n_factorial(5))

# 3. Evaluate binomial coefficients.
def binomial_coefficient(n, k):
    if k == 0 or k == n:
        return 1
    else:
        return binomial_coefficient(n-1, k-1) + binomial_coefficient(n-1, k)
    
print(binomial_coefficient(5, 2))

# 4. Print out Pascal’s triangle.
def pascals_triangle(n):
    for i in range(n):
        for j in range(i+1):
            print(binomial_coefficient(i, j), end=" ")
        print()

pascals_triangle(5)

# 5. Use the sieve of Eratosthenes to find all primes less than 10000.
def sieve_of_eratosthenes(n):
    primes = []

    # Truth table for the sieve
    sieve = [True] * (n+1)
    
    for i in range(2, n+1):
        if sieve[i]:
            primes.append(i)
            for j in range(i*2, n+1, i):
                sieve[j] = False
    return primes

print(sieve_of_eratosthenes(10000))

# 6. Verify Goldbach’s conjecture for all even integers less than 10000.
def goldbach_conjecture(n):
    primes = sieve_of_eratosthenes(n)

    for i in range(4, n, 2):
        found = False
        for j in range(len(primes)):
            if primes[j] > i:
                break

            for k in range(j, len(primes)):
                if primes[k] > i:
                    break
                
                if primes[j] + primes[k] == i:
                    found = True
                    break
            if found:
                break
        if not found:
            return False
    return True

print(goldbach_conjecture(10000))