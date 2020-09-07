directory '/code/' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

cookbook_file '/code/vm_docker.zip' do
    source 'vm_docker.zip'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

cookbook_file '/code/.env' do 
    source 'env.txt'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

zipfile '/code/vm_docker.zip' do 
    into '/code/'
    overwrite true
    #ignore_failure true
end


archive_file 'vm_docker.zip' do
    path '/code/vm_docker.zip'
    destination '/code/'
    action :extract
end

cookbook_file '/code/load.sh' do
    source 'load.sh'
    # owner 'root'
    # group 'root'
    mode '0777'
    # action :create
end

# execute 'start docker' do
#     cwd '/code'
#     command 'sh /code/load.sh'
# end
    

# execute 'start docker' do
#     cwd '/code/'
#     command 'docker-compose up'
#     action :run
# end


bash 'start docker' do
    code <<-EOH
    echo eb76b357-cb60-4dae-8d4f-be8f14a7b5ac | sudo docker login -u liveobjects --password-stdin
    cd /code
    sudo docker-compose up -d 
    sudo docker pull liveobjects/lo_test:latest
    EOH
    action :run
end

chef_sleep 'Wait for container to be up' do
    seconds 10
end

bash 'run test' do
    code <<-EOH
    sudo docker run -d --net code_default liveobjects/lo_test:latest
    EOH
    action :run
end 

# docker_image 'liveobjects/lo_ui_automate:latest' do
#     tag 'latest'
#     action :pull 
#     host 'https://hub.docker.com/'
# end