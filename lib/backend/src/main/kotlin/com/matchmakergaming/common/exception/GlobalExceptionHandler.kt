package com.matchmakergaming.common.exception

import com.matchmakergaming.common.presentation.ApiResponse
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.web.bind.MethodArgumentNotValidException
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.context.request.WebRequest

@ControllerAdvice
class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException::class)
    fun resourceNotFoundException(ex: ResourceNotFoundException): ResponseEntity<ApiResponse<Unit>> {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ApiResponse.error(ex.message ?: "Ressource non trouvée"))
    }

    @ExceptionHandler(BadCredentialsException::class)
    fun badCredentialsException(ex: BadCredentialsException): ResponseEntity<ApiResponse<Unit>> {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
            .body(ApiResponse.error("Identifiants incorrects"))
    }

    @ExceptionHandler(AccessDeniedException::class)
    fun accessDeniedException(ex: AccessDeniedException): ResponseEntity<ApiResponse<Unit>> {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
            .body(ApiResponse.error("Vous n'avez pas les droits nécessaires pour cette action"))
    }

    @ExceptionHandler(MethodArgumentNotValidException::class)
    fun handleValidationExceptions(ex: MethodArgumentNotValidException): ResponseEntity<ApiResponse<Map<String, String?>>> {
        val errors = mutableMapOf<String, String?>()
        ex.bindingResult.fieldErrors.forEach { error ->
            errors[error.field] = error.defaultMessage
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
            .body(ApiResponse(false, "Erreur de validation", errors))
    }

    @ExceptionHandler(Exception::class)
    fun globalExceptionHandler(ex: Exception): ResponseEntity<ApiResponse<Unit>> {
        // En production, on loggue l'erreur complète mais on ne l'affiche pas au client
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(ApiResponse.error("Une erreur interne est survenue : ${ex.message}"))
    }
}

class ResourceNotFoundException(message: String) : RuntimeException(message)
