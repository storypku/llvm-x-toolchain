def clean_dep(dep):
    return str(Label(dep))

def repo():
    native.new_local_repository(
        name = "openssl",
        path = "/usr/include/openssl",
        build_file = clean_dep("//third_party/openssl:openssl.BUILD"),
    )
