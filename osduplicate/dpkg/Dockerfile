FROM debian:bookworm

RUN apt update && apt-get install -y software-properties-common curl

# install fzf since it is written in golang and is included in most of the
# package manager default repos
RUN apt install fzf

RUN sh -c "echo 'deb [signed-by=/etc/apt/keyrings/dataproc.gpg] https://storage.googleapis.com/dataproc-bigtop-repo/2_3_deb12_20251203_064720-RC01 dataproc contrib' > /etc/apt/sources.list.d/dataproc.list"

RUN sh -c "curl -s https://storage.googleapis.com/dataproc-bigtop-repo/2_3_deb12_20251203_064720-RC01/archive.key | gpg --dearmor -o /etc/apt/keyrings/dataproc.gpg"

RUN apt-get update
RUN apt-get install -y spark-core

CMD ["/bin/bash"]
