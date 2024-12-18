import unittest
include jambu
import parseutils
import strutils


proc hexToBytes(hexStr: string): seq[int] =
    var value : int
    for c in hexStr[0..^1]:
        discard parseHex($c, value)
        result.add(value)

proc bytesToHex(bytes: seq[int]): string =
    for byte in bytes:
        result.add(byte.toHex(1))

proc parseTestVectors(filename: string): seq[(seq[int], seq[int], seq[int], seq[int], seq[int])] =
    var key, nonce, plaintext, associatedData, ciphertext: seq[int]
    
    for line in lines(filename):
        echo line
        if line.startsWith("Key = "):
            key = hexToBytes(line[6..^1])
        elif line.startsWith("Nonce = "):
            nonce = hexToBytes(line[8..^1])
        elif line.startsWith("PT = "):
            plaintext = hexToBytes(line[5..^1])
        elif line.startsWith("AD = "):
            associatedData = hexToBytes(line[5..^1])
        elif line.startsWith("CT = "):
            ciphertext = hexToBytes(line[5..^1])
            result.add((key, nonce, plaintext, associatedData, ciphertext))


suite "Jambu Algorithm Tests":
    test "Encryption and Decryption with Test Vectors":
        let testVectors = parseTestVectors("tests/LWC_AEAD_KAT_128_96.txt")
        for (key, nonce, plaintext, associatedData, expectedCiphertext) in testVectors:
            echo "Key: ", key, " Nonce: ", nonce, " PT: ", plaintext, " AD: ", associatedData, " CT: ", expectedCiphertext
            let cipherTextBytes = jambuEncrypt(key, nonce, plaintext, associatedData)
            let decryptedTextBytes = jambuDecrypt(key, nonce, expectedCiphertext, associatedData)

            let cipherText = bytesToHex(cipherTextBytes)
            let decryptedText = bytesToHex(decryptedTextBytes)
            let plaintextStr = bytesToHex(plaintext)
            let expectedCiphertextStr = bytesToHex(expectedCiphertext)

            check decryptedText == plaintextStr
            check ciphertext == expectedCiphertextStr