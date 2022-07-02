ARG YEAR="2022"
ARG NODEJS=""
ARG PYTHON="3.9"

FROM amazonlinux:${YEAR}

RUN yum install -y \
  "nodejs$NODEJS" npm \
  "python$PYTHON" python3-pip python3-setuptools \
  g++ make cmake unzip tar gzip autoconf automake libtool \
  && npm install --global aws-lambda-ric \
  && npx @vercel/ncc build /usr/local/lib/node_modules/aws-lambda-ric/bin/index.js -o /usr/local/lib/node_modules/vercel-ncc-aws-lambda-ric \
  && "python$PYTHON" -m ensurepip --upgrade && "pip$PYTHON" install awslambdaric \
  && touch /.aws-lambda-ric.versions \
  && echo "nodejs=\"$(node --version | cut -c 2-)\"" >> /.aws-lambda-ric.versions \
  && echo "npm=\"$(npm --version)\"" >> /.aws-lambda-ric.versions \
  && echo "aws-lambda-nodejs-runtime-interface-client=\"$(npm show aws-lambda-ric version)\"" >> /.aws-lambda-ric.versions \
  && echo "python3=\"$("python$PYTHON" -c "import platform; print(platform.python_version())")\"" >> /.aws-lambda-ric.versions \
  && echo "pip3=\"$("python$PYTHON" -c "import pip; print(pip.__version__)")\"" >> /.aws-lambda-ric.versions \
  && echo "aws-lambda-python-runtime-interface-client=\"$("python$PYTHON" -c "import awslambdaric; print(awslambdaric.__version__)")\"" >> /.aws-lambda-ric.versions \
  && rm -rf "$(npm config get cache)" \
  && yum remove -y \
  "nodejs$NODEJS" npm \
  python3-pip python3-setuptools \
  g++ make cmake unzip tar gzip autoconf automake libtool \
  && if [[ "$(python3 --version)" != "$("python$PYTHON" --version)" ]]; then yum uninstall "python$PYTHON"; fi

# cannot yum remove -y python3
# Error: Problem: The operation would result in removing the following protected packages: dnf
