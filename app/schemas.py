# schemas.py

from pydantic import BaseModel
from typing import List, Any, Optional

class ExpectedResult(BaseModel):
    """Defines how to validate the result of the validation_command."""
    type: str  # e.g., "exact_match", "contains_string", "integer_greater_than"
    value: Any

class CheckLogic(BaseModel):
    """The logic used to set up and validate a challenge."""
    setup_commands: Optional[List[str]] = None
    validation_command: str
    expected_result: ExpectedResult

class GradePayload(BaseModel):
    """The structure of an incoming grading request."""
    language: str
    user_code: str
    check_logic: CheckLogic

class GradeResult(BaseModel):
    """The structure of the response sent back after grading."""
    output: str
    is_correct: bool
    feedback_message: str