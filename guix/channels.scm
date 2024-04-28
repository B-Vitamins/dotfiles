;; -*- mode: scheme; -*-
(use-modules (guix channels))
(use-modules (guix ci))

(list (channel
        (name 'guix)
        (url "https://git.savannah.gnu.org/git/guix.git")
        (branch "master")
        (introduction
         (make-channel-introduction "9edb3f66fd807b096b48283debdcddccfea34bad"
          (openpgp-fingerprint
           "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      (channel
        (name 'myguix)
        (url "https://github.com/b-vitamins/myguix.git")
        (branch "master")
        (introduction
         (make-channel-introduction "85d58b09dc71e9dc9834b666b658f79d2e212d65"
          (openpgp-fingerprint
           "883B CA6B D275 A5F2 673C  C5DD 2AD3 2FC0 2A50 01F7"))))
      (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (branch "master")
        (introduction
         (make-channel-introduction "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
          (openpgp-fingerprint
           "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
      (channel
        (name 'guix-science)
        (url "https://github.com/guix-science/guix-science.git")
        (introduction
         (make-channel-introduction "b1fe5aaff3ab48e798a4cce02f0212bc91f423dc"
          (openpgp-fingerprint
           "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446"))))
      (channel
        (name 'guix-science-nonfree)
        (url "https://github.com/guix-science/guix-science-nonfree.git")
        (introduction
         (make-channel-introduction "58661b110325fd5d9b40e6f0177cc486a615817e"
          (openpgp-fingerprint
           "CA4F 8CF4 37D7 478F DA05  5FD4 4213 7701 1A37 8446")))))
