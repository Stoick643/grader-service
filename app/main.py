# main.py

from fastapi import FastAPI
from . import schemas
from .docker_manager import manager

app = FastAPI()

@app.on_event("startup")
async def startup_event():
    await manager.startup()

@app.on_event("shutdown")
async def shutdown_event():
    await manager.shutdown()

@app.post("/grade", response_model=schemas.GradeResult)
async def grade_submission(payload: schemas.GradePayload):
    """
    Receives a submission, uses the docker_manager to execute it,
    and returns the result.
    """
    return await manager.execute_code_in_container(
        language=payload.language,
        user_code=payload.user_code,
        check_logic=payload.check_logic,
    )