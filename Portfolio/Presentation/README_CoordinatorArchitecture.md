# Coordinator Architecture - Communication Between Coordinators

## Descripción

Esta documentación explica la arquitectura de coordinators implementada en la aplicación Portfolio, donde los coordinators se comunican entre sí siguiendo el patrón Parent-Child Coordinator.

## Arquitectura General

```
AppCoordinator (Principal)
├── LoginCoordinator (Child)
│   └── UserProfileCoordinator (Grandchild)
├── AssetCoordinator (Futuro)
└── SettingsCoordinator (Futuro)
```

## Jerarquía de Coordinators

### 1. AppCoordinator (Principal)
- **Responsabilidad**: Coordinator principal de la aplicación
- **Child Coordinators**: LoginCoordinator
- **Vista Principal**: ContentView
- **Factory**: AppCoordinatorFactory

### 2. LoginCoordinator (Child)
- **Responsabilidad**: Gestionar el flujo de login
- **Child Coordinators**: UserProfileCoordinator
- **Parent Coordinator**: AppCoordinator
- **Factory**: LoginCoordinatorFactory

### 3. UserProfileCoordinator (Grandchild)
- **Responsabilidad**: Gestionar el perfil de usuario
- **Parent Coordinator**: LoginCoordinator
- **Factory**: UserProfileCoordinatorFactory

## Flujo de Navegación

### Flujo Correcto (Implementado)
```
portfolioApp → AppCoordinator → LoginCoordinator → UserProfileCoordinator
     ↓              ↓                ↓                    ↓
ContentView → makeLoginFlow() → makeUserProfileView() → UserProfileView
```

### Flujo Incorrecto (Anterior)
```
LoginView → UserProfileCoordinatorFactory.create().makeUserProfileView()
```

## Implementación

### AppCoordinator
```swift
class AppCoordinator: AppCoordinatorProtocol {
    private lazy var loginCoordinator: LoginCoordinatorProtocol = {
        LoginCoordinator(
            sessionRepository: sessionRepository,
            loginRepository: loginRepository,
            googleSignInRepository: googleSignInRepository,
            carAssetRepository: carAssetRepository,
            userProfileRepository: userProfileRepository
        )
    }()
    
    func makeLoginFlow() -> LoginRouterView {
        return loginCoordinator.makeLoginRouterView()
    }
}
```

### LoginCoordinator
```swift
class LoginCoordinator: LoginCoordinatorProtocol {
    private lazy var userProfileCoordinator: UserProfileCoordinatorProtocol = {
        UserProfileCoordinator(
            userProfileRepository: userProfileRepository,
            carAssetRepository: carAssetRepository
        )
    }()
    
    func makeUserProfileView() -> UserProfileView {
        return userProfileCoordinator.makeUserProfileView()
    }
}
```

### LoginView
```swift
struct LoginView: View {
    private let coordinator: LoginCoordinatorProtocol
    
    .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
        coordinator.makeUserProfileView()  // Delegación al coordinator
    }
}
```

## Beneficios de esta Arquitectura

### 1. Separación de Responsabilidades
- **AppCoordinator**: Navegación global de la app
- **LoginCoordinator**: Flujo de autenticación
- **UserProfileCoordinator**: Gestión de perfil de usuario

### 2. Comunicación Jerárquica
- Los coordinators se comunican solo con sus padres/hijos
- No hay comunicación directa entre coordinators no relacionados
- La navegación fluye de manera predecible

### 3. Inyección de Dependencias
- Cada coordinator recibe las dependencias que necesita
- Las dependencias se comparten entre coordinators relacionados
- Fácil testing con mocks

### 4. Testing Mejorado
```swift
// Testing con coordinators anidados
let mockUserProfileCoordinator = MockUserProfileCoordinator()
let loginCoordinator = LoginCoordinator(
    userProfileCoordinator: mockUserProfileCoordinator
)

let userProfileView = loginCoordinator.makeUserProfileView()
// Verifica que usa mockUserProfileCoordinator.makeUserProfileView()
```

## Patrones Implementados

### 1. Parent-Child Coordinator Pattern
- **Parent**: Mantiene referencia a child coordinators
- **Child**: Delega al parent cuando necesita navegar fuera de su scope
- **Lifecycle**: Child coordinators se liberan cuando el parent se libera

### 2. Factory Pattern
- **AppCoordinatorFactory**: Crea AppCoordinator
- **LoginCoordinatorFactory**: Crea LoginCoordinator
- **UserProfileCoordinatorFactory**: Crea UserProfileCoordinator

### 3. Dependency Injection
- **Constructor Injection**: Dependencias se pasan en el init
- **Shared Dependencies**: Repositories compartidos entre coordinators
- **Lazy Loading**: Use cases se crean cuando se necesitan

## Reglas de la Arquitectura

### 1. Navegación
- ✅ **Correcto**: View → Coordinator → Child Coordinator
- ❌ **Incorrecto**: View → CoordinatorFactory → Coordinator

### 2. Comunicación
- ✅ **Correcto**: Coordinator → Child Coordinator
- ❌ **Incorrecto**: Coordinator → Coordinator no relacionado

### 3. Dependencias
- ✅ **Correcto**: Parent inyecta dependencias al Child
- ❌ **Incorrecto**: Child crea sus propias dependencias

### 4. Testing
- ✅ **Correcto**: Mock coordinators completos
- ❌ **Incorrecto**: Mock solo use cases individuales

## Ejemplo de Uso

### Producción
```swift
// En portfolioApp.swift
ContentView(coordinator: AppCoordinatorFactory.create())

// En ContentView
coordinator.makeLoginFlow()

// En LoginView
coordinator.makeUserProfileView()
```

### Testing
```swift
let appCoordinator = AppCoordinatorFactory.createForTesting(
    sessionRepository: MockSessionRepository(),
    loginRepository: MockLoginRepository(),
    googleSignInRepository: MockGoogleSignInRepository(),
    carAssetRepository: MockCarAssetRepository(),
    userProfileRepository: MockUserProfileRepository()
)
```

## Próximos Pasos

### 1. Aplicar a Otros Módulos
- **AssetCoordinator**: Para gestión de assets
- **SettingsCoordinator**: Para configuración
- **TabCoordinator**: Para navegación entre tabs

### 2. Mejoras Futuras
- **Deep Linking**: Coordinators manejan deep links
- **State Management**: Coordinators mantienen estado de navegación
- **Analytics**: Coordinators reportan eventos de navegación

### 3. Testing Avanzado
- **Integration Tests**: Probar flujos completos
- **Navigation Tests**: Verificar navegación correcta
- **Memory Tests**: Verificar liberación de memoria

## Conclusión

Esta arquitectura proporciona:
- **Escalabilidad**: Fácil agregar nuevos módulos
- **Mantenibilidad**: Código organizado y predecible
- **Testabilidad**: Testing aislado y completo
- **Consistencia**: Patrón uniforme en toda la app 