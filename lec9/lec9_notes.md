# Security and Cryptography
## Entropy
* Entropy is a measure of randomness
* Entropy is measured in bits, and when selecting uniformly at random from a set of possible outcomes, the entropy is equal to `log_2(# of possibilities)`

---

## Hash functions
* A cryptographic hash function maps data of arbitrary size to a fixed size, and has some special properties
* `hash(value: array<byte>) -> vector<byte, N>  (for some fixed N)`
* SHA1: map arbitrary-sized inputs to 160-bit outputs
    ```shell
    printf 'hello' | sha1sum
    aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
    printf 'hello' | sha1sum
    aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d
    printf 'Hello' | sha1sum 
    f7ff9e8b7bb2e09b70935a5d785e0cc5d9d0abf0
    ```
* properties of hash functions
    * Deterministic: the same input always generates the same output.
    * Non-invertible: it is hard to find an input `m` such that `hash(m) = h `for some desired output `h`.
    * Target collision resistant: given an input `m_1`, it’s hard to find a different input `m_2` such that `hash(m_1) = hash(m_2)`.
    * Collision resistant: it’s hard to find two inputs m_1 and m_2 such that `hash(m_1) = hash(m_2)` (note that this is a strictly stronger property than target collision resistance).
* Note: while it may work for certain purposes, SHA-1 is no longer considered a strong cryptographic hash function
* Applications
    * Git, for content-addressed storage.
    * A short summary of the contents of a file. Software can often be downloaded from (potentially less trustworthy) mirrors, e.g. Linux ISOs, and it would be nice to not have to trust them. The official sites usually post hashes alongside the download links (that point to third-party mirrors), so that the hash can be checked after downloading a file.
    * Commitment schemes. Suppose you want to commit to a particular value, but reveal the value itself later. For example, I want to do a fair coin toss “in my head”, without a trusted shared coin that two parties can see. I could choose a value `r = random()`, and then share `h = sha256(r)`. Then, you could call heads or tails (we’ll agree that even `r` means heads, and odd `r` means tails). After you call, I can reveal my value `r`, and you can confirm that I haven’t cheated by checking s`ha256(r)` matches the hash I shared earlier.

---

## Key derivation functions
* KDFs are used for a number of applications, including producing fixed-length output for use as keys in other cryptographic algorithms
* KDFs are deliberately slow, in order to slow down offline brute-force attacks
* Applications
    * Producing keys from passphrases for use in other cryptographic algorithms (e.g. symmetric cryptography, see below).
    * Storing login credentials. Storing plaintext passwords is bad; the right approach is to generate and store a random salt salt = random() for each user, store KDF(password + salt), and verify login attempts by re-computing the KDF given the entered password and the stored salt.

---

## Symmetric crytography
* API
    ```shell
    keygen() -> key  (this function is randomized)

    encrypt(plaintext: array<byte>, key) -> array<byte>  (the ciphertext)
    decrypt(ciphertext: array<byte>, key) -> array<byte>  (the plaintext)
    ```
* The encrypt function has the property that given the output (ciphertext), it’s hard to determine the input (plaintext) without the key. 
* The decrypt function has the obvious correctness property, that `decrypt(encrypt(m, k), k) = m`.
* Applications
    * Encrypting files for storage in an untrusted cloud service. This can be combined with KDFs, so you can encrypt a file with a passphrase. Generate `key = KDF(passphrase)`, and then store `encrypt(file, key)`.
        ```shell
        openssl aes-256-cbc -salt -in lec9_notes.md -out ciphertext.md
        openssl aes-256-cbc -d -in ciphertext.md -out plaintext.md
        cmp plaintext.md ciphertext.md
        ```
---

## Asymmetric cryptography
* The term “asymmetric” refers to there being two keys, with two different roles. A private key, as its name implies, is meant to be kept private, while the public key can be publicly shared and it won’t affect security (unlike sharing the key in a symmetric cryptosystem). Asymmetric cryptosystems provide the following set of functionality, to encrypt/decrypt and to sign/verify:
    ```shell
    keygen() -> (public key, private key)  (this function is randomized)

    encrypt(plaintext: array<byte>, public key) -> array<byte>  (the ciphertext)
    decrypt(ciphertext: array<byte>, private key) -> array<byte>  (the plaintext)

    sign(message: array<byte>, private key) -> array<byte>  (the signature)
    verify(message: array<byte>, signature: array<byte>, public key) -> bool  (whether or not the signature is valid)
    ```

* The encrypt/decrypt functions have properties similar to their analogs from symmetric cryptosystems. A message can be encrypted using the public key. Given the output (ciphertext), it’s hard to determine the input (plaintext) without the private key. The decrypt function has the obvious correctness property, that `decrypt(encrypt(m, public key), private key) = m`.
* The sign/verify functions have the same properties that you would hope physical signatures would have, in that it’s hard to forge a signature. No matter the message, without the private key, it’s hard to produce a signature such that `verify(message, signature, public key)` returns true. And of course, the verify function has the obvious correctness property that `verify(message, sign(message, private key), public key) = true`.
* Applications
    * PGP email encryption. People can have their public keys posted online (e.g. in a PGP keyserver, or on Keybase). Anyone can send them encrypted email.
    * Private messaging. Apps like Signal and Keybase use asymmetric keys to establish private communication channels.
    * Signing software. Git can have GPG-signed commits and tags. With a posted public key, anyone can verify the authenticity of downloaded software.
* Key distribution
    * out-of-band public key
    * web of trust
    * social proof
---

## Case studies
* Password managers: KeePassXC, pass, 1Password
* Two-factor authentication: YubiKey
* Full disk encryption: FileVault on macOS, BitLocker on Windiws, cryptsetup+LUKS on LINUX
* Private messaging: Signal, Keybase
* SSH


---

## Exercises
1. $Entropy_1 = log_2(100000) * 4 \approx 66.44 bits$  
   $Entropy_2 = log_2(52 + 10) * 8 \approx 47.63 bits$  
   So obviously, the first password is stronger.  
   $Time_1 = 100000^4/10000\approx 10^{16} s\approx7.61\times10^9 years$  
   $Time_2 = 62^8/10000\approx2.18\times10^{10}s\approx16616.45years$
2. Finish
3. Finish
4. Finish
