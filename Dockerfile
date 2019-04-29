FROM twobombs/cudacluster

# clone repos
RUN git clone --recursive https://github.com/twobombs/qrack.git
RUN git clone --recursive https://github.com/SoftwareQuTech/SimulaQron.git
RUN git clone --recursive https://github.com/vm6502q/ProjectQ.git
RUN git clone --recursive https://github.com/XanaduAI/pennylane-pq.git

# install features
RUN apt-get update && apt-get -y install build-essential cmake wget vim-common opencl-headers curl libfreetype6-dev doxygen nginx && apt-get clean all

# install metricbeat for ES 7.0.0
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.0.0-amd64.deb && dpkg -i metricbeat-7.0.0-amd64.deb && rm metricbeat-7.0.0-amd64.deb

# Qrack install & dependancies 
RUN cd /qrack/include && mkdir CL
RUN cd /qrack && mkdir _build && cd _build && cmake .. && make all && make install && cd .. && doxygen doxygen.config && mv /var/www/html /var/www/old_html && mkdir /var/www/html/qrack && ln -s /qrack/doc/html /var/www/html/qrack

# install python3
RUN apt-get install -y python3 python3-pip python3-tk
# Set a UTF-8 locale - this is needed for some python packages to play nice
RUN apt-get -y install language-pack-en
ENV LANG="en_US.UTF-8"

# ProjectQ install
# pybind11 workaround
RUN pip3 install pybind11
RUN pip3 install sphinx sphinx_rtd_theme
# rebuild workaround
RUN cd /ProjectQ && pip3 install --user .
RUN cd /ProjectQ && pip3 install --user  --global-option="--with-qracksimulator" .

# Install SimulaQron 
RUN pip3 install simulaqron
RUN cd /ProjectQ/docs && make html && mkdir /var/www/html/projectq && ln -s /ProjectQ/docs/_build/html /var/www/html/projectq

# Install pennylane
RUN pip3 install pennylane_pq
RUN cd /pennylane-pq && make test

# Install jupyter
RUN pip3 install jupyter

# node run script
COPY run-node /root/

EXPOSE 80 8801-8811 8888
