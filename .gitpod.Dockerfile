FROM gitpod/workspace-full

# Install terrform CLI
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - \
    && sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && sudo apt-get update \
    && sudo apt-get install terraform -y \
    && sudo rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm awscliv2.zip
