# DPKG OS Testbed

This testbed is developed to verify that scalibr adds the exploitability signals (related to `osduplicate`) only to packages which were added through default repositories.

Inventories returned from files which are part of `dpkg` packages installed via default repository receive an OS-level advisory which is more precise and less prone to false positives, while packages installed by other means do not receive any OS-level advisory and should be covered using language-level extractors.

In this example the `Dockerfile` installs:

- `fzf` from a default repository
- `spark-core` from a custom repository

## Verification Steps

Build the image and run the testbed:

```sh
docker build --platform linux/amd64 -t osduplicate-dpkg .
# mount scalibr into the container
docker run --rm -it --platform linux/amd64 -v ./../scalibr:/usr/bin/scalibr osduplicate-dpkg
```

Verify that fzf was installed via a main repository while spark-core was installed from a custom one:

```sh
apt-cache policy fzf
apt-cache policy spark-core
```

Verify that fzf and spark-core are both detected by their respective language extractor:

```sh
scalibr -plugins="java/archive,go/binary" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -C 10 'usr/bin/fzf'
cat /tmp/result.textproto | grep -C 10 'usr/lib/spark/jars/spark-core_2.12-3.5.3.jar'
```

Verify that fzf and spark-core are both detected by the "os/dpkg" extractor:

```sh
scalibr -plugins="os/dpkg" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -C 10 '\sname: "fzf"'
cat /tmp/result.textproto | grep -C 10 '\sname: "spark-core"'
```

Verify that exploitability_signals are only added to fzf related packages:

```sh
/tmp/scalibr -plugins="vex/os-duplicate/dpkg,os/dpkg,java/archive,go/binary" -o textproto=/tmp/result.textproto
cat /tmp/result.textproto | grep -C 10 'exploitability_signals'
```
