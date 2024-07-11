run:
    odin run . -o:speed

test:
    odin test . -define:ODIN_TEST_TRACK_MEMORY=false
