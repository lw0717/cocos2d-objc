//
//  CCEffectUtils.m
//  cocos2d-ios
//
//  Created by Thayer J Andrews on 7/17/14.
//
//

#import "CCEffectUtils.h"



static const float CCEffectUtilsMinRefract = -0.25;
static const float CCEffectUtilsMaxRefract = 0.043;


CGAffineTransform CCEffectUtilsWorldToEnvironmentTransform(CCSprite *environment)
{
    CGAffineTransform worldToEnvNode = environment.worldToNodeTransform;
    CGAffineTransform envNodeToEnvTexture = environment.nodeToTextureTransform;
    CGAffineTransform worldToEnvTexture = CGAffineTransformConcat(worldToEnvNode, envNodeToEnvTexture);
    return worldToEnvTexture;
}

GLKVector4 CCEffectUtilsTangentInEnvironmentSpace(GLKMatrix4 effectToWorldMat, GLKMatrix4 worldToEnvMat)
{
    GLKMatrix4 effectToEnvTextureMat = GLKMatrix4Multiply(effectToWorldMat, worldToEnvMat);
    
    GLKVector4 refractTangent = GLKVector4Make(1.0f, 0.0f, 0.0f, 0.0f);
    refractTangent = GLKMatrix4MultiplyVector4(effectToEnvTextureMat, refractTangent);
    return GLKVector4Normalize(refractTangent);
}

GLKMatrix4 CCEffectUtilsMat4FromAffineTransform(CGAffineTransform at)
{
    return GLKMatrix4Make(at.a,  at.b,  0.0f,  0.0f,
                          at.c,  at.d,  0.0f,  0.0f,
                          0.0f,  0.0f,  1.0f,  0.0f,
                          at.tx, at.ty, 0.0f,  1.0f);
}

float CCEffectUtilsConditionRefraction(float refraction)
{
    NSCAssert((refraction >= -1.0f) && (refraction <= 1.0f), @"Supplied refraction out of range [-1..1].");
    
    // Lerp between min and max
    if (refraction >= 0.0f)
    {
        return CCEffectUtilsMaxRefract * refraction;
    }
    else
    {
        return CCEffectUtilsMinRefract * -refraction;
    }
}

float CCEffectUtilsConditionShininess(float shininess)
{
    NSCAssert((shininess >= 0.0f) && (shininess <= 1.0f), @"Supplied shininess out of range [0..1].");
    return clampf(shininess, 0.0f, 1.0f);
}

float CCEffectUtilsConditionFresnelBias(float bias)
{
    NSCAssert((bias >= 0.0f) && (bias <= 1.0f), @"Supplied bias out of range [0..1].");
    return clampf(bias, 0.0f, 1.0f);
}

float CCEffectUtilsConditionFresnelPower(float power)
{
    NSCAssert(power >= 0.0f, @"Supplied power out of range [0..inf].");
    return (power < 0.0f) ? 0.0f : power;
}

void CCEffectUtilsPrintMatrix(NSString *label, GLKMatrix4 matrix)
{
    NSLog(@"%@", label);
    NSLog(@"%f %f %f %f", matrix.m00, matrix.m01, matrix.m02, matrix.m03);
    NSLog(@"%f %f %f %f", matrix.m10, matrix.m11, matrix.m12, matrix.m13);
    NSLog(@"%f %f %f %f", matrix.m20, matrix.m21, matrix.m22, matrix.m23);
    NSLog(@"%f %f %f %f", matrix.m30, matrix.m31, matrix.m32, matrix.m33);
}



