
# Project Rules

## Tech Stack
- Frontend: React
- Backend: Node.js / Express
- Database: MySQL
- Environment: Docker

## Token and Quota Efficiency
- Inspect only files relevant to the current task.
- Do not scan the entire repository unnecessarily.
- Avoid repeating explanations already provided.
- Prefer concise responses.
- Reuse existing components and utilities.
- Do not rewrite unrelated files.
- Do not install packages unless necessary.

## Workflow
1. Identify relevant files.
2. Explain the proposed changes briefly.
3. Modify only the required files.
4. Run focused checks.
5. Summarize modified files and remaining issues.

## Safety
- Never expose secrets or credentials.
- Do not modify .env files without approval.
- Do not delete data or run database migrations without approval.
- Ask before destructive commands.

Implement the requested feature with minimal context and changes.

Task: Create a responsive restaurant table management page.

Constraints:
- Inspect only relevant frontend files.
- Reuse existing components and styles.
- Do not modify backend APIs or database.
- Do not refactor unrelated code.
- Provide a short plan before editing.
- Run only relevant checks.
- Finish with a concise summary of modified files and test results.
Công việc	Công cụ đề xuất
Giải thích code, SQL đơn giản	Ollama Local
Viết component React đơn giản	Gemini Flash
Chỉnh sửa CSS, responsive	Gemini Flash
Debug nhiều file	Gemini Pro
Thiết kế kiến trúc backend	Gemini Pro
Refactor phức tạp	Model mạnh hơn khi cần
Kiểm tra Git diff, chạy test	Công cụ local trước