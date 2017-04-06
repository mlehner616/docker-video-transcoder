FROM ruby:2.4

ENV \
	OS_DEPS="software-properties-common" \
	BUILD_DEPS=" \
        build-essential \
		# libappindicator-dev \
		# libass-dev \
		# libbz2-dev \
		# libdbus-glib-1-dev \
		# libfontconfig1-dev \
		# libfreetype6-dev \
		# libfribidi-dev \
		# libgstreamer-plugins-base0.10-dev \
		# libgstreamer0.10-dev \
		# libgudev-1.0-dev \
		# libogg-dev \
		# libsamplerate-dev \
		# libtheora-dev \
		# libvorbis-dev \
		# libwebkit-dev \
		# nasm \
		# yasm \
		# zlib1g-dev \
        # autoconf \
        # automake \
        # checkinstall \
        # intltool \
        # libcurl4-openssl-dev \
        # libevent-dev \
        # libglib2.0-dev \
        # libgtk2.0-dev \
        # libmp3lame-dev \
        # libnotify-dev \
        # libtool \
        # libx264-dev \
        # libxml2-dev \
        # pkg-config \
        # subversion" \
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
	# apt-get update && \
	# apt-get -y install $OS_DEPS && \
	apt-get update && \
	apt-get install --force-yes -y deb-multimedia-keyring && \
	apt-key update && \
	apt-get update

RUN apt-get -y install $BUILD_DEPS

# Build and install ffmpeg from source
# RUN mkdir /ffmpeg-src && \
# 	cd /ffmpeg-src && \
# 	wget http://www.ffmpeg.org/releases/ffmpeg-3.2.tar.xz && \
# 	tar -xvf ffmpeg-3.2.tar.xz && \
# 	cd ffmpeg-3.2 && \
# 	./configure \
# 		--pkg-config-flags="--static" \
# 		--prefix="ffmpeg_build" \
# 		--bindir="/bin" \
# 		--enable-gpl \
# 		--enable-libx264 && \
# 	make -j 8 && \
# 	cat RELEASE && \
# 	checkinstall && \
# 	make install && \
# 	rm -rf /ffmpeg-src

# Build and install Handbrake-cli from source
# RUN mkdir /handbrake-src && \
# 	cd /handbrake-src && \
# 	wget https://github.com/HandBrake/HandBrake/archive/1.0.3.tar.gz && \
# 	tar -xvf 1.0.3.tar.gz && \
# 	cd HandBrake-1.0.3 && \
# 	./configure \
# 		--enable-ff-mpeg2 \
# 		--enable-fdk-aac \
# 		--arch=x86_64 \
# 		--optimize=speed \
# 		--bindir="/bin" \
# 		--prefix="handbrake_build && \
# 	make -j 8 && \
# 	make install && \
# 	checkinstall && \
# 	rm -rf /handbrake-src

RUN	apt-get -y install $RUN_DEPS

RUN	gem install video_transcoding

CMD ["transcode-video"]
