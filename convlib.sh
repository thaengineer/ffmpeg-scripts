# convert input to x265 aac mp4 using hw acceleration
function convert()
{
  $HOME/.bin/ffmpeg -hide_banner -i "${1}" -c:v hevc_videotoolbox -pix_fmt p010le -profile:v main10 -b:v 3000K -c:a aac -ar 44100 -ac 2 -b:a 128K -tag:v hvc1 "VIDEO_$(date +%Y%m%d)_$(date +%H%M%S).mp4"
}

# convert input to x265 aac mp4
function convslow()
{
  $HOME/.bin/ffmpeg -hide_banner -i "${1}" -c:v libx265 -pix_fmt yuv420p10le -profile:v main10 -c:a aac -ar 44100 -ac 2 -b:a 128K -tag:v hvc1 "VIDEO_$(date +%Y%m%d)_$(date +%H%M%S).mp4"
}

# convert input to 720p x265 aac mp4
function conv720p()
{
  $HOME/.bin/ffmpeg -hide_banner -i "${1}" -vf scale=1280x720:flags=lanczos -c:v hevc_videotoolbox -pix_fmt p010le -profile:v main10 -b:v 3000K -c:a aac -ar 44100 -ac 2 -b:a 128K -tag:v hvc1 "VIDEO_$(date +%Y%m%d)_$(date +%H%M%S).mp4"
}

# convert input to 1080p x265 aac mp4
function conv1080p()
{
  $HOME/.bin/ffmpeg -hide_banner -i "${1}" -vf scale=1920x1080:flags=lanczos -c:v hevc_videotoolbox -pix_fmt p010le -profile:v main10 -b:v 3000K -c:a aac -ar 44100 -ac 2 -b:a 128K -tag:v hvc1 "VIDEO_$(date +%Y%m%d)_$(date +%H%M%S).mp4"
}

# tag input with hvc1 for mac os
function taghvc1()
{
  $HOME/.bin/ffmpeg -hide_banner -i "${1}" -c:v copy -c:a copy -tag:v hvc1 "VIDEO_$(date +%Y%m%d)_$(date +%H%M%S).mp4"
}

# convert input to aac m4a and strip video
function convaac()
{
  $HOME/.bin/ffmpeg -hide_banner -i "${1}" -vn -c:a aac -ar 44100 -ac 2 -b:a 128K "AUDIO_$(date +%Y%m%d)_$(date +%H%M%S).m4a"
}

# convert input to mp3 and strip video
function convmp3()
{
$HOME/.bin/ffmpeg -hide_banner -i "${1}" -vn -c:a libmp3lame -ar 44100 -ac 2 -b:a 128K "AUDIO_$(date +%Y%m%d)_$(date +%H%M%S).mp3"
}

# probe input file audio and video codec
function probe()
{
  ffprobe -hide_banner -show_format "${1}"
}

# convert episodes with S[0-9][1-9]E[0-9][1-9].m[kp][4v] naming convention to to x265 aac mp4
function convEpisodes()
{
  for i in $(seq -w 01 $(ls | wc -l)); do
    INFILE="$(ls S[0-9][1-9]E${i}.m[kp][4v])"
    ASAMPLE="$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=nokey=1:noprint_wrappers=1 S[0-9][1-9]E${i}.m[kp][4v] | tr -d '[:space:]')"
    if [ ${ASAMPLE} -ne 44100 ]; then
      ffmpeg -hide_banner -i S[0-9][1-9]E${i}.m[kp][4v] -c:v hevc_videotoolbox -pix_fmt p010le -profile:v main10 -b:v 3000K -c:a aac -ar 44100 -ac 2 -b:a 128K -tag:v hvc1 "VIDEO.mp4"
      mv VIDEO.mp4 S[0-9][1-9]E${i}.mp4
    else
      echo "[!] ${INFILE}: Already converted."
    fi
  done
}

# convert movies with S[0-9][1-9]E[0-9][1-9].m[kp][4v] naming convention to to x265 aac mp4
function convMovies()
{
  for i in *.m[kp][4v]; do
    ASAMPLE="$(ffprobe -v error -select_streams a:0 -show_entries stream=sample_rate -of default=nokey=1:noprint_wrappers=1 "${i}" | tr -d '[:space:]')"
    if [ ${ASAMPLE} -ne 44100 ]; then
      ffmpeg -hide_banner -i "${i}" -c:v hevc_videotoolbox -pix_fmt p010le -profile:v main10 -b:v 3000K -c:a aac -ar 44100 -ac 2 -b:a 128K -tag:v hvc1 "VIDEO.mp4"
      mv VIDEO.mp4 "${i}"
    else
      echo "[!] ${i}: Already converted."
    fi
  done
}
