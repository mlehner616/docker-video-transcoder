FROM ruby:2.4

ENV \
	OS_DEPS="software-properties-common" \
	BUILD_DEPS=" \
        build-essential \
        " \
    RUN_DEPS=" \
		handbrake \
		handbrake-cli \
    	ffmpeg \
		libav-tools \
		mkvtoolnix \
		mp4v2-utils"

WORKDIR /videos
VOLUME ["/videos"]

# Install OS Dependencies and extra repo
RUN \
	which ffmpeg || true && \
	sh -c 'echo "deb http://www.deb-multimedia.org jessie main" >> /etc/apt/sources.list' && \
	echo "deb http://httpredir.debian.org/debian jessie-backports main contrib non-free"  >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get install --force-yes -y deb-multimedia-keyring && \
	apt-key update && \
	apt-get update

RUN apt-get -y install $BUILD_DEPS

RUN	apt-get -y install $RUN_DEPS

RUN	gem install video_transcoding

CMD ["transcode-video"]
