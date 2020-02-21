FROM rust:latest as tectonic_install

RUN apt-get update && apt-get install -yq --no-install-suggests --no-install-recommends --force-yes libfontconfig1-dev libgraphite2-dev libharfbuzz-dev libicu-dev zlib1g-dev
RUN cargo install tectonic --force --vers 0.1.12

WORKDIR /usr/src/tex
RUN wget 'https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/2.11/binaries/Linux/biber-linux_x86_64.tar.gz'
RUN tar -xvzf biber-linux_x86_64.tar.gz
RUN chmod +x biber
RUN cp biber /usr/bin/biber

COPY *.tex ./
COPY *.bib ./
COPY *.cls ./
# first run - keep files for biber
RUN tectonic --keep-intermediates --reruns 0 cv.tex
# do the biber
RUN biber main
# one last tectonic run over all files
RUN for f in *.tex; do tectonic $f; done

# use a lightweight debian - no need for whole rust environment
FROM debian:stretch-slim as ship_debian
RUN apt-get update \
    && apt-get install -yq --no-install-suggests --no-install-recommends --force-yes libfontconfig1 libgraphite2-3 libharfbuzz0b libicu57 zlib1g libharfbuzz-icu0 libssl1.1 ca-certificates \
    && apt-get -yq --no-install-suggests --no-install-recommends --force-yes install fonts-font-awesome texlive-fonts-extra texlive-latex-recommended \
    && apt-get clean && rm -rf /var/lib/apt/lists/* 

# copy tectonic binary to new image
COPY --from=tectonic_install /usr/local/cargo/bin/tectonic /usr/bin/
# reuse tectonic cache from compiling tex files
COPY --from=tectonic_install /root/.cache/Tectonic/ /root/.cache/Tectonic/
# copy biber binary to new image
COPY --from=tectonic_install /usr/bin/biber /usr/bin/ 

WORKDIR /usr/src/tex
