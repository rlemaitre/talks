target := "target"

build: copy_assets
    #!/usr/bin/env sh
     echo "🚀 Building website" > /dev/stderr
     for file in $(find website -name '*.adoc' -print); do
         just build_page "$file"
     done
     echo "👍 Done" > /dev/stderr
    echo "🚀 Building talks" > /dev/stderr
    for file in $(find slides -name 'index.adoc' -print); do
        just build_talk "$file"
    done
    echo "👍 Done" > /dev/stderr

copy_assets:
    #!/usr/bin/env sh
    echo "  📦 Copying website assets" > /dev/stderr
    rsync --archive --checksum --human-readable website/assets {{target}}/
    echo "  📦 Copying talks assets" > /dev/stderr
    rsync --archive --checksum --human-readable slides/assets {{target}}/

build_talk src:
    #!/usr/bin/env sh
    echo "  👷‍ Building {{src}}" > /dev/stderr
    file=$(realpath {{src}})
    src_dir=$(dirname {{src}})
    dst_dir=$(echo $(realpath $src_dir) | sed 's/slides/{{target}}/')
    mkdir -p $(dirname $dst_dir)
    bundle exec asciidoctor-revealjs --base-dir $src_dir --source-dir $src_dir --destination-dir $dst_dir $file

build_page src:
    #!/usr/bin/env sh
    echo "  👷‍ Building {{src}}" > /dev/stderr
    src_dir=$(dirname {{src}})
    dst_dir=$(echo $(realpath $src_dir) | sed 's/website/{{target}}/')
    file=$(basename {{src}})
    mkdir -p $(dirname $dst_dir)
    asciidoctor --base-dir $src_dir --source-dir $src_dir --destination-dir $dst_dir {{src}}

clean:
    #!/usr/bin/env sh
    rm -fr {{target}}
    echo "🚮 Cleaned up" > /dev/stderr
