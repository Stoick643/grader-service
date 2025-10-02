# docker_manager.py

import docker
from . import schemas

# Map language names to the Docker images we will build
GRADER_IMAGES = {
    "redis": "grader-image-redis",
    "sql": "grader-image-sql"
}
POOL_SIZE = 3 # Number of warm containers to keep per language

class ContainerManager:
    def __init__(self):
        self.client = docker.from_env()
        self.pool = {} # e.g. {"redis": [container1, container2]}

    async def startup(self):
        """Creates a pool of warm, ready-to-use containers on startup."""
        print("Starting up and warming container pools...")
        for lang, image_name in GRADER_IMAGES.items():
            self.pool[lang] = []
            for i in range(POOL_SIZE):
                container = self.client.containers.run(image_name, detach=True, tty=True)
                self.pool[lang].append(container)
                print(f"Started container {container.short_id} for {lang}")

    async def shutdown(self):
        """Stops and removes all containers on shutdown."""
        print("Shutting down and cleaning up containers...")
        for lang in self.pool:
            for container in self.pool[lang]:
                print(f"Stopping container {container.short_id}")
                container.stop()
                container.remove()

# app/docker_manager.py

    async def execute_code_in_container(
        self, language: str, user_code: str, check_logic: schemas.CheckLogic
    ) -> schemas.GradeResult:
        
        # TODO: Implement actual pooling logic (get/return container)
        container = self.pool[language][0]

        # This is a simple way to map a language to its command-line tool.
        # We can make this more robust later.
        cli_command = ""
        if language == "redis":
            cli_command = "redis-cli"
        elif language == "sql":
            cli_command = "sqlite3 /data/company.db"

        # 1. Run setup commands if they exist
        if check_logic.setup_commands:
            for cmd in check_logic.setup_commands:
                # Prepend the cli_command
                full_cmd = f"{cli_command} {cmd}"
                container.exec_run(full_cmd)

        # 2. Run the user's code and capture the output
        full_user_cmd = f"{cli_command} {user_code}"
        exit_code, output_bytes = container.exec_run(full_user_cmd)
        output = output_bytes.decode("utf-8").strip()

        # 3. Run the validation command
        full_validation_cmd = f"{cli_command} {check_logic.validation_command}"
        _, validation_output_bytes = container.exec_run(full_validation_cmd)
        validation_output = validation_output_bytes.decode("utf-8").strip()

        # 4. Grade the result
        # TODO: Implement a more robust grading logic dispatcher
        is_correct = False
        feedback = "Grading logic not fully implemented."
        if check_logic.expected_result.type == "exact_match":
            # For Redis TTL, the result can be 59 or 60 depending on timing.
            # We'll need a more flexible check later.
            if validation_output == str(check_logic.expected_result.value):
                is_correct = True
                feedback = "Correct!"
            else:
                feedback = f"Incorrect. Expected a result of '{check_logic.expected_result.value}' but got '{validation_output}'."

        # TODO: Reset container state before returning to pool
        
        return schemas.GradeResult(
            output=output,
            is_correct=is_correct,
            feedback_message=feedback,
        )

# Create a single instance of the manager to be used by the app
manager = ContainerManager()