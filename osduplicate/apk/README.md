# APK OS Testbed

This testbed is developed to verify that scalibr adds the exploitability signals (related to `osduplicate`) only to packages which were added through default repositories.

Inventories returned from files which are part of `apk` packages installed via default repository receive an OS-level advisory which is more precise and less prone to false positives, while packages installed by other means do not receive any OS-level advisory and should be covered using language-level extractors.

In this example the `Dockerfile` installs:

- `fzf` from a default repository
- `orb` from a custom repository

## Verification Steps

Build the image and run the testbed:

```sh
docker build --platform linux/amd64 -t osduplicate-apk .
# mount scalibr into the container
docker run --rm -it --platform linux/amd64 -v ./../scalibr:/usr/bin/scalibr osduplicate-apk
```

Verify that fzf was installed via a main repository while orb was installed from a custom one:

```sh
apk policy fzf
apk policy orb
```

Verify that fzf and orb are both detected:

```sh
scalibr -plugins="go/binary" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -C 10 'usr/bin/fzf'
cat /tmp/result.textproto | grep -C 10 'usr/bin/orb'
```

Verify that fzf and orb are both detected by the "os/apk" extractor:

```sh
scalibr -plugins="os/apk" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -C 10 '\sname: "fzf"'
cat /tmp/result.textproto | grep -C 10 '\sname: "orb"'
```

Verify that exploitability_signals are only added to fzf related packages:

```sh
scalibr -plugins="vex/os-duplicate/apk,os/apk,go/binary" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -C 10 'exploitability_signals'
```
