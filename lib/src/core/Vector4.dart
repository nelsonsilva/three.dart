part of three;

/**
 * @author supereggbert / http://www.paulbrunt.co.uk/
 * @author philogb / http://blog.thejit.org/
 * @author mikael emtinger / http://gomo.se/
 * @author egraether / http://egraether.com/
 *
 * Ported to Dart from JS by:
 * @author rob silverton / http://www.unwrong.com/
 */

class Vector4 extends SIMDVector<Vector4> implements IVector4 {

  Vector4( [num x = 0, num y = 0, num z = 0, num w = 1] ) : super(x, y, z, w);


  setValues( num x, num y, num z, num w ) => _setValues(x, y, z, w);

  copy( SIMDVector v ) {
    super.copy(v);

    if ( v is IVector3 ) {
      w = 1.0;
    }
  }


  Vector4 clone() {
    return new Vector4( x, y, z, w );
  }

  Vector4 setAxisAngleFromQuaternion( Quaternion q ) {

    // http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToAngle/index.htm

    // q is assumed to be normalized

    w = 2 * Math.acos( q.w );

    var s = Math.sqrt( 1 - q.w * q.w );

    if ( s < 0.0001 ) {

       x = 1;
       y = 0;
       z = 0;

    } else {

       x = q.x / s;
       y = q.y / s;
       z = q.z / s;

    }

    return this;

  }

  setAxisAngleFromRotationMatrix( m ) {

    // http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToAngle/index.htm

    // assumes the upper 3x3 of m is a pure rotation matrix (i.e, unscaled)

    num angle, x, y, z,   // variables for result
      epsilon = 0.01,   // margin to allow for rounding errors
      epsilon2 = 0.1;   // margin to distinguish between 0 and 180 degrees

    var te = m.elements,

      m11 = te[0], m12 = te[4], m13 = te[8],
      m21 = te[1], m22 = te[5], m23 = te[9],
      m31 = te[2], m32 = te[6], m33 = te[10];

    if ( ( ( m12 - m21 ).abs() < epsilon )
      && ( ( m13 - m31 ).abs() < epsilon )
      && ( ( m23 - m32 ).abs() < epsilon ) ) {

      // singularity found
      // first check for identity matrix which must have +1 for all terms
      // in leading diagonal and zero in other terms

      if ( ( ( m12 + m21 ).abs() < epsilon2 )
        && ( ( m13 + m31 ).abs() < epsilon2 )
        && ( ( m23 + m32 ).abs() < epsilon2 )
        && ( ( m11 + m22 + m33 - 3 ).abs() < epsilon2 ) ) {

        // this singularity is identity matrix so angle = 0

        setValues( 1, 0, 0, 0 );

        return this; // zero angle, arbitrary axis

      }

      // otherwise this singularity is angle = 180

      angle = Math.PI;

      var xx = ( m11 + 1 ) / 2;
      var yy = ( m22 + 1 ) / 2;
      var zz = ( m33 + 1 ) / 2;
      var xy = ( m12 + m21 ) / 4;
      var xz = ( m13 + m31 ) / 4;
      var yz = ( m23 + m32 ) / 4;

      if ( ( xx > yy ) && ( xx > zz ) ) { // m11 is the largest diagonal term

        if ( xx < epsilon ) {

          x = 0;
          y = 0.707106781;
          z = 0.707106781;

        } else {

          x = Math.sqrt( xx );
          y = xy / x;
          z = xz / x;

        }

      } else if ( yy > zz ) { // m22 is the largest diagonal term

        if ( yy < epsilon ) {

          x = 0.707106781;
          y = 0;
          z = 0.707106781;

        } else {

          y = Math.sqrt( yy );
          x = xy / y;
          z = yz / y;

        }

      } else { // m33 is the largest diagonal term so base result on this

        if ( zz < epsilon ) {

          x = 0.707106781;
          y = 0.707106781;
          z = 0;

        } else {

          z = Math.sqrt( zz );
          x = xz / z;
          y = yz / z;

        }

      }

      // TODO - check if this is needed - setValues( x, y, z, angle );

      return this; // return 180 deg rotation

    }

    // as we have reached here there are no singularities so we can handle normally

    var s = Math.sqrt( ( m32 - m23 ) * ( m32 - m23 )
             + ( m13 - m31 ) * ( m13 - m31 )
             + ( m21 - m12 ) * ( m21 - m12 ) ); // used to normalize

    if ( s.abs() < 0.001 ) s = 1;

    // prevent divide by zero, should not happen if matrix is orthogonal and should be
    // caught by singularity test above, but I've left it in just in case

    x = ( m32 - m23 ) / s;
    y = ( m13 - m31 ) / s;
    z = ( m21 - m12 ) / s;
    w = Math.acos( ( m11 + m22 + m33 - 1 ) / 2 );

    return this;

  }
}
