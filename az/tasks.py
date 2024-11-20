"""
Tasks wrapper.
"""
from os.path import dirname, abspath
from invoke import task, Collection


# Global
ROOT_PATH = dirname(abspath(__file__))

# Docker image
IMAGE_NAME = "org/azure-iac-modules"
IMAGE_WORKDIR = "/modules"
CONTAINER_NAME = "azure-iac-modules"


@task()
def docker_build(cnt):
    """Build image for docker environment."""
    cnt.run(f"docker build -t {IMAGE_NAME} .")


@task()
def docker_create(cnt, git_user_name, git_user_email):
    """Create and run docker environment container."""
    cnt.run(f"docker run -ti -d --name {CONTAINER_NAME} --net=host -v '{ROOT_PATH}:{IMAGE_WORKDIR}' {IMAGE_NAME}")
    # Install hooks
    cnt.run(f"docker exec {CONTAINER_NAME} pre-commit install")
    # Git global config
    cnt.run(f"docker exec {CONTAINER_NAME} git config --global user.email '{git_user_email}'")
    cnt.run(f"docker exec {CONTAINER_NAME} git config --global user.name '{git_user_name}'")


@task()
def docker_stop(cnt):
    """Stop docker environment container."""
    cnt.run(f"docker stop {CONTAINER_NAME}")


@task()
def docker_status(cnt):
    """Status of docker environment container."""
    cnt.run(f"docker ps -a --filter 'name={CONTAINER_NAME}'")


@task(post=[docker_status])
def docker_start(cnt):
    """Start docker environment container."""
    cnt.run(f"docker start {CONTAINER_NAME}")


@task(docker_stop)
def docker_delete(cnt):
    """Delete docker environment container."""
    cnt.run(f"docker rm {CONTAINER_NAME}")


@task()
def docker_purge(cnt):
    """Delete docker image for docker environment."""
    cnt.run(f"docker rmi {IMAGE_NAME}")


@task(docker_build)
def docker_build_and_run(cnt, git_user_name, git_user_email):
    """Spin up whole docker environment."""
    docker_create(cnt, git_user_name=git_user_name, git_user_email=git_user_email)


@task(docker_stop, docker_delete)
def docker_stop_and_delete(cnt):
    """Teardown whole docker environment."""


@task(docker_stop, docker_delete, docker_purge)
def docker_stop_and_delete_and_purge(cnt):
    """Cleanup whole docker environment."""


ns = Collection()


docker_image = Collection("image")
docker_image.add_task(docker_build, "build")
docker_image.add_task(docker_purge, "delete")

docker_container = Collection("container")
docker_container.add_task(docker_create, "create")
docker_container.add_task(docker_stop, "stop")
docker_container.add_task(docker_start, "start")
docker_container.add_task(docker_delete, "delete")
docker_container.add_task(docker_status, "status")

docker = Collection("docker")
docker.add_task(docker_build_and_run, "up")
docker.add_task(docker_stop_and_delete, "down")
docker.add_task(docker_stop_and_delete_and_purge, "clean")
docker.add_collection(docker_image)
docker.add_collection(docker_container)

ns.add_collection(docker)
