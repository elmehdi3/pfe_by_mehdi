package com.matchmakergaming.common.infrastructure.storage

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import software.amazon.awssdk.core.sync.RequestBody
import software.amazon.awssdk.services.s3.S3Client
import software.amazon.awssdk.services.s3.model.PutObjectRequest
import java.util.*

@Service
class FileStorageService(
    private val s3Client: S3Client,
    @Value("\${aws.s3.bucket}") private val bucketName: String
) {

    fun uploadAvatar(userId: Long, file: MultipartFile): String {
        val fileName = "avatars/$userId/${UUID.randomUUID()}-${file.originalFilename}"
        
        val putObjectRequest = PutObjectRequest.builder()
            .bucket(bucketName)
            .key(fileName)
            .contentType(file.contentType)
            .acl("public-read")
            .build()

        s3Client.putObject(putObjectRequest, RequestBody.fromBytes(file.bytes))
        
        // Retourne l'URL publique de l'image
        return "https://$bucketName.s3.amazonaws.com/$fileName"
    }

    fun deleteFile(fileUrl: String) {
        val key = fileUrl.substringAfter(".com/")
        s3Client.deleteObject { it.bucket(bucketName).key(key) }
    }
}
