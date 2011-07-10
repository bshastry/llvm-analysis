module Data.LLVM.Private.Types.Attributes (
  -- * Types
  ArithFlags(..),
  CmpPredicate(..),
  CallingConvention(..),
  LinkageType(..),
  VisibilityStyle(..),
  ParamAttribute(..),
  FunctionAttribute(..),
  Endian(..),
  DataLayout(..),
  TargetTriple(..),
  AlignSpec(..),
  Assembly(..),
  -- * Values
  defaultDataLayout
  ) where

#include "c++/marshal.h"

import Control.DeepSeq
import Data.ByteString.Char8 ( ByteString, unpack )

{#enum LinkageType {} deriving (Eq) #}
instance Show LinkageType where
  show LTExternal = ""
  show LTAvailableExternally = "available_externally"
  show LTLinkOnceAny = "linkonce"
  show LTLinkOnceODR = "linkonce_odr"
  show LTWeakAny = "weak"
  show LTWeakODR = "weak_odr"
  show LTAppending = "appending"
  show LTInternal = "internal"
  show LTPrivate = "private"
  show LTLinkerPrivate = "linker_private"
  show LTLinkerPrivateWeak = "linker_private_weak"
  show LTLinkerPrivateWeakDefAuto = "linker_private_weak_def_auto"
  show LTDLLImport = "dllimport"
  show LTDLLExport = "dllexport"
  show LTExternalWeak = "extern_weak"
  show LTCommon = "common"

instance NFData LinkageType


{#enum VisibilityStyle {} deriving (Eq) #}

instance Show VisibilityStyle where
  show VisibilityDefault = ""
  show VisibilityHidden = "hidden"
  show VisibilityProtected = "protected"

instance NFData VisibilityStyle


{#enum ArithFlags {} deriving (Eq) #}

instance Show ArithFlags where
  show ArithNone = ""
  show ArithNUW = "nuw"
  show ArithNSW = "nsw"
  show ArithBoth = "nuw nsw"

instance NFData ArithFlags



{#enum CmpPredicate {underscoreToCase} deriving (Eq) #}

instance Show CmpPredicate where
  show FCmpFalse = "false"
  show FCmpOeq = "oeq"
  show FCmpOgt = "ogt"
  show FCmpOge = "oge"
  show FCmpOlt = "olt"
  show FCmpOle = "ole"
  show FCmpOne = "one"
  show FCmpOrd = "ord"
  show FCmpUno = "uno"
  show FCmpUeq = "ueq"
  show FCmpUgt = "ugt"
  show FCmpUge = "uge"
  show FCmpUlt = "ult"
  show FCmpUle = "ule"
  show FCmpUne = "une"
  show FCmpTrue = "true"
  show ICmpEq = "eq"
  show ICmpNe = "ne"
  show ICmpUgt = "ugt"
  show ICmpUge = "uge"
  show ICmpUlt = "ult"
  show ICmpUle = "ule"
  show ICmpSgt = "sgt"
  show ICmpSge = "sge"
  show ICmpSlt = "slt"
  show ICmpSle = "sle"

instance NFData CmpPredicate


{#enum CallingConvention {} deriving (Eq) #}
instance Show CallingConvention where
  show CC_C = ""
  show CC_FAST = "fastcc"
  show CC_COLD = "coldcc"
  show CC_GHC = "cc 10"
  show CC_X86_STDCALL = "cc 64"
  show CC_X86_FASTCALL = "cc 65"
  show CC_ARM_APCS = "cc 66"
  show CC_ARM_AAPCS = "cc 67"
  show CC_ARM_AAPCS_VFP = "cc 68"
  show CC_MSP430_INTR = "cc 69"
  show CC_X86_THISCALL = "cc 70"
  show CC_PTX_KERNEL = "cc 71"
  show CC_PTX_DEVICE = "cc 72"
  show CC_MBLAZE_INTR = "cc 73"
  show CC_MBLAZE_SVOL = "cc 74"

instance NFData CallingConvention


 -- Representing Assembly
data Assembly = Assembly !ByteString
                deriving (Eq, Ord)

instance Show Assembly where
  show (Assembly txt) = unpack txt

instance NFData Assembly where
  rnf a@(Assembly txt) = txt `seq` a `seq` ()


-- Param attributes

data ParamAttribute = PAZeroExt
                    | PASignExt
                    | PAInReg
                    | PAByVal
                    | PASRet
                    | PANoAlias
                    | PANoCapture
                    | PANest
                    | PAAlign !Int
                    deriving (Eq, Ord)

instance NFData ParamAttribute

instance Show ParamAttribute where
  show PAZeroExt = "zeroext"
  show PASignExt = "signext"
  show PAInReg = "inreg"
  show PAByVal = "byval"
  show PASRet = "sret"
  show PANoAlias = "noalias"
  show PANoCapture = "nocapture"
  show PANest = "nest"
  show (PAAlign i) = "align " ++ show i

-- Function Attributes

data FunctionAttribute = FAAlignStack !Int
                       | FAAlwaysInline
                       | FAHotPatch
                       | FAInlineHint
                       | FANaked
                       | FANoImplicitFloat
                       | FANoInline
                       | FANoRedZone
                       | FANoReturn
                       | FANoUnwind
                       | FAOptSize
                       | FAReadNone
                       | FAReadOnly
                       | FASSP
                       | FASSPReq
                       deriving (Eq, Ord)

instance NFData FunctionAttribute

instance Show FunctionAttribute where
  show (FAAlignStack n) = "alignstack(" ++ show n ++ ")"
  show FAAlwaysInline = "alwaysinline"
  show FAHotPatch = "hotpatch"
  show FAInlineHint = "inlinehint"
  show FANaked = "naked"
  show FANoImplicitFloat = "noimplicitfloat"
  show FANoInline = "noinline"
  show FANoRedZone = "noredzone"
  show FANoReturn = "noreturn"
  show FANoUnwind = "nounwind"
  show FAOptSize = "optsize"
  show FAReadNone = "readnone"
  show FAReadOnly = "readonly"
  show FASSP = "ssp"
  show FASSPReq = "sspreq"

data Endian = EBig
            | ELittle
              deriving (Eq, Ord)

instance NFData Endian

instance Show Endian where
  show EBig = "E"
  show ELittle = "e"

-- Track the ABI alignment and preferred alignment
data AlignSpec = AlignSpec !Int !Int
                 deriving (Show, Eq, Ord)

instance NFData AlignSpec where
  rnf a@(AlignSpec i1 i2) = i1 `seq` i2 `seq` a `seq` ()

data TargetTriple = TargetTriple ByteString
                    deriving (Eq)

instance Show TargetTriple where
  show (TargetTriple t) = unpack t

instance NFData TargetTriple where
  rnf t@(TargetTriple t') = t' `seq` t `seq` ()

data DataLayout = DataLayout { endianness :: Endian
                             , pointerAlign :: (Int, AlignSpec)
                             , intAlign :: [ (Int, AlignSpec) ]
                             , vectorAlign :: [ (Int, AlignSpec) ]
                             , floatAlign :: [ (Int, AlignSpec) ]
                             , aggregateAlign :: [ (Int, AlignSpec) ]
                             , stackAlign :: [ (Int, AlignSpec) ]
                             , nativeWidths :: [ Int ]
                             }
                  deriving (Show, Eq)

instance NFData DataLayout where
  rnf d = endianness d `deepseq` pointerAlign d `deepseq`
           intAlign d `deepseq` vectorAlign d `deepseq`
           floatAlign d `deepseq` aggregateAlign d `deepseq`
           stackAlign d `deepseq` nativeWidths d `deepseq` d `seq` ()

-- Defaults specified by LLVM.  I think there can only be one pointer
-- align specification, though it isn't explicitly stated
defaultDataLayout :: DataLayout
defaultDataLayout = DataLayout { endianness = EBig
                               , pointerAlign = (64, AlignSpec 64 64)
                               , intAlign = [ (1, AlignSpec 8 8)
                                            , (8, AlignSpec 8 8)
                                            , (16, AlignSpec 16 16)
                                            , (32, AlignSpec 32 32)
                                            , (64, AlignSpec 32 64)
                                            ]
                               , vectorAlign = [ (64, AlignSpec 64 64)
                                               , (128, AlignSpec 128 128)
                                               ]
                               , floatAlign = [ (32, AlignSpec 32 32)
                                              , (64, AlignSpec 64 64)
                                              ]
                               , aggregateAlign = [ (0, AlignSpec 0 1) ]
                               , stackAlign = [ (0, AlignSpec 64 64) ]
                               , nativeWidths = [] -- Set.empty
                               }
