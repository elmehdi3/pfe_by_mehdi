package com.matchmakergaming.auth.presentation

import com.matchmakergaming.auth.application.PasswordResetService
import com.matchmakergaming.auth.application.RefreshTokenService
import com.matchmakergaming.auth.application.SocialAuthService
import com.matchmakergaming.auth.application.TwoFactorService
import com.matchmakergaming.auth.application.VerificationService
import com.matchmakergaming.auth.presentation.payload.request.LoginRequest
import com.matchmakergaming.auth.presentation.payload.request.SignupRequest
import com.matchmakergaming.auth.presentation.payload.request.SocialLoginRequest
import com.matchmakergaming.auth.presentation.payload.response.JwtResponse
import com.matchmakergaming.auth.presentation.payload.response.MessageResponse
import com.matchmakergaming.common.presentation.ApiResponse
import com.matchmakergaming.security.jwt.JwtUtils
import com.matchmakergaming.security.services.UserDetailsImpl
import com.matchmakergaming.users.domain.model.User
import com.matchmakergaming.users.infrastructure.persistence.UserRepository
import com.matchmakergaming.users.application.PresenceService
import com.matchmakergaming.security.audit.AuditService
import jakarta.servlet.http.HttpServletRequest
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.bind.annotation.*

@CrossOrigin(origins = ["*"], maxAge = 3600)
@RestController
@RequestMapping("/api/v1/auth")
class AuthController(
    private val authenticationManager: AuthenticationManager,
    private val userRepository: UserRepository,
    private val encoder: PasswordEncoder,
    private val jwtUtils: JwtUtils,
    private val refreshTokenService: RefreshTokenService,
    private val presenceService: PresenceService,
    private val auditService: AuditService,
    private val verificationService: VerificationService,
    private val passwordResetService: PasswordResetService,
    private val twoFactorService: TwoFactorService,
    private val socialAuthService: SocialAuthService
) {

    @PostMapping("/signin")
    fun authenticateUser(
        @Valid @RequestBody loginRequest: LoginRequest,
        request: HttpServletRequest
    ): ResponseEntity<ApiResponse<JwtResponse>> {
        val authentication = authenticationManager.authenticate(
            UsernamePasswordAuthenticationToken(loginRequest.pseudo, loginRequest.password)
        )

        val userDetails = authentication.principal as UserDetailsImpl
        val user = userRepository.findById(userDetails.id).get()

        if (!user.isVerified) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Compte non vérifié."))
        }

        if (user.is2faEnabled) {
            twoFactorService.generateAndSendCode(user)
            return ResponseEntity.ok(ApiResponse(true, "Code 2FA envoyé", null))
        }

        return generateLoginResponse(authentication, user, request)
    }

    @PostMapping("/social-login")
    fun socialLogin(
        @Valid @RequestBody socialRequest: SocialLoginRequest,
        request: HttpServletRequest
    ): ResponseEntity<ApiResponse<JwtResponse>> {
        val user = socialAuthService.processSocialLogin(socialRequest.idToken, socialRequest.provider)
        
        // Création de l'authentification Spring Security manuelle pour OAuth2
        val userDetails = com.matchmakergaming.security.services.UserDetailsImpl.build(user)
        val authentication = UsernamePasswordAuthenticationToken(userDetails, null, userDetails.authorities)
        
        return generateLoginResponse(authentication, user, request)
    }

    private fun generateLoginResponse(
        authentication: org.springframework.security.core.Authentication, 
        user: User, 
        request: HttpServletRequest
    ): ResponseEntity<ApiResponse<JwtResponse>> {
        SecurityContextHolder.getContext().authentication = authentication
        val userDetails = authentication.principal as UserDetailsImpl
        val jwt = jwtUtils.generateJwtToken(authentication)
        val refreshToken = refreshTokenService.createRefreshToken(userDetails.id)

        presenceService.setUserOnline(userDetails.id)
        auditService.log(userDetails.id, "LOGIN", "Connexion réussie (${user.email})", request.remoteAddr)

        val response = JwtResponse(
            token = jwt,
            refreshToken = refreshToken.token,
            id = userDetails.id,
            pseudo = userDetails.username,
            email = user.email, 
            roles = userDetails.authorities.map { it.authority }
        )

        return ResponseEntity.ok(ApiResponse.success(response))
    }

    @PostMapping("/signup")
    fun registerUser(@Valid @RequestBody signUpRequest: SignupRequest, request: HttpServletRequest): ResponseEntity<ApiResponse<MessageResponse>> {
        if (userRepository.existsByPseudo(signUpRequest.pseudo)) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Erreur: Pseudo déjà utilisé !"))
        }

        if (userRepository.existsByEmail(signUpRequest.email)) {
            return ResponseEntity.badRequest().body(ApiResponse.error("Erreur: Email déjà utilisé !"))
        }

        val user = User(
            pseudo = signUpRequest.pseudo,
            email = signUpRequest.email,
            password = encoder.encode(signUpRequest.password)
        )

        val savedUser = userRepository.save(user)
        verificationService.createVerificationToken(savedUser)
        auditService.log(savedUser.id, "SIGNUP", "Nouveau compte créé", request.remoteAddr)

        return ResponseEntity.ok(ApiResponse.success(MessageResponse("Inscription réussie !"), "Veuillez vérifier votre email."))
    }

    // ... (verifyAccount, resendVerification, forgotPassword, resetPassword, logout)
}
