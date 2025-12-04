// Simulated database with localStorage
interface User {
  id: string
  username: string
  email: string
  telefono: string
  password_hash: string
  codigo_verificacion: string
  email_verificado: boolean
  token_sesion: string | null
}

// Get all users from localStorage
function getUsers(): User[] {
  if (typeof window === "undefined") return []
  const users = localStorage.getItem("users_db")
  return users ? JSON.parse(users) : []
}

// Save users to localStorage
function saveUsers(users: User[]) {
  if (typeof window === "undefined") return
  localStorage.setItem("users_db", JSON.stringify(users))
}

export async function getUser(username: string): Promise<User | null> {
  const users = getUsers()
  return users.find((u) => u.username === username) || null
}

export async function getUserByEmail(email: string): Promise<User | null> {
  const users = getUsers()
  return users.find((u) => u.email === email) || null
}

export async function getUserByToken(token: string): Promise<User | null> {
  const users = getUsers()
  return users.find((u) => u.token_sesion === token) || null
}

export async function createUser(
  username: string,
  email: string,
  passwordHash: string,
  telefono: string,
  code: string,
): Promise<void> {
  const users = getUsers()
  const newUser: User = {
    id: Math.random().toString(36).substr(2, 9),
    username,
    email,
    telefono,
    password_hash: passwordHash,
    codigo_verificacion: code,
    email_verificado: false,
    token_sesion: null,
  }
  users.push(newUser)
  saveUsers(users)
}

export async function verifyEmailCode(email: string, code: string): Promise<void> {
  const users = getUsers()
  const userIndex = users.findIndex((u) => u.email === email && u.codigo_verificacion === code)
  if (userIndex !== -1) {
    users[userIndex].email_verificado = true
    saveUsers(users)
  }
}

export async function updateVerificationCode(email: string, newCode: string): Promise<void> {
  const users = getUsers()
  const userIndex = users.findIndex((u) => u.email === email)
  if (userIndex !== -1) {
    users[userIndex].codigo_verificacion = newCode
    saveUsers(users)
  }
}

export async function saveTokenIfMissing(userId: string, currentToken: string | null): Promise<string> {
  const users = getUsers()
  const userIndex = users.findIndex((u) => u.id === userId)

  if (userIndex !== -1) {
    if (!currentToken) {
      const newToken = Math.random().toString(36).substr(2, 20)
      users[userIndex].token_sesion = newToken
      saveUsers(users)
      return newToken
    }
    return currentToken
  }

  throw new Error("User not found")
}

export async function clearUserToken(token: string): Promise<void> {
  const users = getUsers()
  const userIndex = users.findIndex((u) => u.token_sesion === token)
  if (userIndex !== -1) {
    users[userIndex].token_sesion = null
    saveUsers(users)
  }
}
