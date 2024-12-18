const
  FrameBitsIV = 0x10
  FrameBitsAD = 0x30
  FrameBitsPC = 0x50
  FrameBitsFinalization = 0x70

  NROUND1 = 128 * 5
  NROUND2 = 128 * 8

proc stateUpdate(state, key : var seq[int], numberOfSteps: int) : void =
    var t1, t2, t3, t4, feedback : int
    for i in 0..(numberOfSteps shr 5):
        t1 = (state[1] shr 15) | (state[2] shl 17)  # 47 = 1*32+15 
        t2 = (state[2] shr 6)  | (state[3] shl 26)  # 47 + 23 = 70 = 2*32 + 6 
        t3 = (state[2] shr 21) | (state[3] shl 11)  # 47 + 23 + 15 = 85 = 2*32 + 21      
        t4 = (state[2] shr 27) | (state[3] shl 5)   # 47 + 23 + 15 + 6 = 91 = 2*32 + 27 
        feedback = state[0] ^ t1 ^ (~(t2 & t3)) ^ t4 ^ (i & 3)
        (state[0], state[1], state[2], state[3]) = (state[1], state[2], state[3], feedback)



proc initialization(key, iv, state : var seq[int] ): void =
    for i in 0..3:
        state[i] = 0
    
    stateUpdate(state, key, NROUND2)

    for i in 0..3:
        state[1] = state[1] ^ FrameBitsIV
        stateUpdate(state, key, NROUND1)
        state[3] = state[3] ^ iv[i]

proc processAd(k, ad, state : var seq[int]) : void =
    for i in 0..((ad.len shr 2) - 1):
        state[1] = state[1] ^ FrameBitsAD
        stateUpdate(state, k, NROUND1)
        state[3] = state[3] ^ ad[i]

    if ((ad.len & 3) > 0):
        state[1] = state[1] ^ FrameBitsAD
        stateUpdate(state, k, NROUND1)
        for i in 0..((ad.len & 3) - 1):
            state[12 + i] = state[12 + i] ^ (ad[(i shl 2) + i])
        state[1] = state[1] ^ (ad.len & 3)

func jambuEncrypt(key, nonce, plaintext, associatedData: seq[int]): seq[int] =
    var 
        i : uint64
        j : int
        check = 0
        mac : arr[8, uint]
        state : arr[4, uint]

    
    result = plaintext

func jambuDecrypt(key, nonce, ciphertext, associatedData: seq[int]) : seq[int] = 
    result = cipherText