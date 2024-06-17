---
title: Where are my keys?
subtitle: Demystifiying Matrix Cryptography
description: |
  If you've used Matrix for any period of time, you will know that Matrix has a
  lot of keys. There are keys for devices, keys for users, keys for messages,
  keys for the keys for messages, keys for backups, keys for the keys to the
  backups. In this talk, I'm going to try to provide a framework for thinking
  about keys in Matrix. I also will discuss some of the pitfalls both baked into
  the spec and those which are a function of the nature of a networked protocol.
---

Hello, my name is Sumner, I'm a software engineer at Automattic working on
Beeper and today I'm going to be talking about cryptography in Matrix.

End-to-end encryption is one of the things which brought me to Matrix, and I'm
sure that it's one of the factors that brought many of you to Matrix as well.

However, Matrix's user experience with cryptography is often confusing. Part of
this is due to the incompetence of other chat networks. Many don't even provide
any cryptographically-guaranteed security, and others do so in a way that does
not truly leave the user in control of their keys.

Only a few networks (Signal) truly leave the user in control, and their UX is
arguably worse than Matrix.

In this talk, I want to demystify cryptography in Matrix and provide you with a
framework for understanding what all of the keys are for.

Beeper is an app that allows users to connect all of their chat networks to a
single app. You can have FB, WA... TODO all in the same app.

Beeper is built on top of the Matrix protocol, and all Beeper accounts are
Matrix accounts on the beeper.com homeserver. We are building towards a world in
which everyone just talks over the Matrix network to one another, rather than
having to use bridges, but until that day comes, we use bridges as a way to
allow people to come into the ecosystem without having to sacrifice talking to
specific friends just because they haven't yet come over to Beeper.

I work on the Platform team at Beeper. Our team does three main things:

1. **We maintain backend services and infrastructure.** I gave a talk at the
   2022 Berlin Matrix Summit about our bridge architecture, focusing around
   hungryserv which is the custom homeserver implementation designed for
   handling unfederated bridge traffic.

   We also maintain all of the kubernetes infrastructure, user management
   services, a Synapse instance, and many other backend services.
2. **We maintain all of the mautrix bridges** including WA, Signal, Meta, ...
   LinkedIn.
3. **We maintain a Go client SDK** that our next-generation clients like the new
   Android app use.

I've done some of all of these things, but lately, building the Go SDK has taken
up a significant portion of my time. I implemented key backup (and corrupted
multiple key backups in the process). I built the interactive QR code
verification framework (and generated many a bad QR code in the process). And
most recently, I've been experimenting with a pure-Go implementation of the
Olm/Megolm protocols originally written by @DerLukas as a way to replace libolm
in our clients.

As you can see, a lot of the things that I have been working on revolve around
cryptography in Matrix which leads me to the topic of this talk: **keys in
Matrix.**

If you've used Matrix for any period of time, you will know that Matrix has a
lot of keys. There are keys for devices, keys for users, keys for messages, keys
for the keys for messages, keys for backups, keys for the keys to the backups.
In this talk, I'm going to try to provide a framework for thinking about keys in
Matrix. I also will discuss some of the quirks and pitfalls that are either
baked into the spec and which are a function of the nature of a networked
protocol.

I want to demystify why you might see a red shield, or why you might encounter a
message that you can't decrypt. I'm going to touch on the technical details of
the encryption primitives that Matrix uses, but I am by no means an expert in
cryptography. I took a single cryptography class, and I attended lecture maybe
twice, so I'll limit myself to the bare minimum discussion of encryption
primitives so as not to embarrass myself.

My goal is also to highlight _what_ each of the keys does and which users
experiences each key enables for the users.

## Reasons for Cryptography

At its core, there are two pairs of primitive operations that cryptosystems[^1]
provide to us which are interesting:

- Encryption and Decryption
- Signing and Signature Verification

[^1]: A cryptosystem is a TODO

With these two primitive operations, we can build a private, verifiable
messaging system.

Matrix uses cryptography for two main purposes:

1. **Privacy:** only the people who are part of the conversation should be
   allowed to view the messages of the conversation. As an additional benefit of
   how Matrix achieves this, encrypted messages cannot be tampered with by a
   man-in-the-middle actor without the receiving party knowing.
1. **Identity:** verifying that a user or device is who they say they are. Note
   that one of the most important parts of identity this is verifying that our
   own devices are under our own control and we should allow our own clients to
   share keys to it.

(I'm focused here on the client view of cryptography. There are also keys
involved with the server-to-server federation API, but I haven't studied that at
all. From what I understand, it's significantly more straightforward.)

These two goals split Matrix cryptography in two. There are many layers built up
on either side to make a good user experience around the keys required to
accomplish both goals, so we'll now take a look at both sides and build up from
the primitives, but first, we need to make a short journey into the depths of
cryptosystems.

## Cryptosystems

TODO

- Symmetric vs asymmetric encryption
- RSA vs Elliptic Curve
- HKDF
- Diffie-Hellman key exchanges

## Privacy

Fundamentally, messages need to be encrypted with a key that both parties share
and agree upon.

The simplest thing that work provide sufficient security would be to require
users to do the following on each message send:

1. Generate a random AES key
2. Meet in person with every person in the chat and type the key into the other
   person's device before sending every message. Obviously this is not a
good experience for anybody, so we have to devise a way to share the key that
doesn't involve meeting before every message and typing AES keys.

We want something that allows us to (a) securely share the key and (b) rotate
the key automatically after each message.

### Securely Sharing Keys

N^2 problem: we need to share the key to every user in the chat.

Luckily, we already know about established methods for exchanging keys across an
insecure channel: Diffie-Hellman!

But for Diffie-Hellman, we need a key on both sides to do the ECDH against. TODO
one time keys

### Rotating Keys

HKDF

- 2 fundamental types of keys:
  - message keys - encrypt the content of the message
  - identity keys - cryptographically verify that the message was sent by the
    person who claims to have sent it

- 3 ways to get message keys
  - via sharing megolm keys via olm sessions
  - via key chatter between own devices
  - via key backup

  - q: how to know whether we should send a key to another device?
    - verification

- identity keys - device authenticity
  - device signing keys
  - cross-signing keys
